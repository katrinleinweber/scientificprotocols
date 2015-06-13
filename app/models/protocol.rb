require 'open-uri'

class Protocol < ActiveRecord::Base
  extend FriendlyId
  attr_accessor :skip_callbacks
  include Octokitable
  include Gistable
  include Citeable
  include ProtocolObserver
  include Workflow
  acts_as_taggable
  friendly_id :title, use: :slugged
  has_many :protocol_managers
  has_many :users, through: :protocol_managers
  has_many :ratings
  default_scope { order('LOWER(title)::bytea') }
  scope :managed_by, -> (user) { joins(:protocol_managers).where(protocol_managers: { user: user }) }
  validates :title, presence: true
  validates :description, presence: true
  searchable do
    text :title, boost: 5
    text :description
    time :created_at
    string :workflow_state
    string :tag_list, multiple: true
    string :sort_title do
      title.downcase.gsub(/^(an?|the)\b/, '')
    end
  end
  self.per_page = 10

  APPROVED_SORT = [
    'created_at asc',
    'created_at desc',
    'title asc',
    'title desc'
  ]

  workflow do
    state :draft do
      event :publish, transitions_to: :published
    end
    state :published do
      event :unpublish, transitions_to: :draft
    end
  end

  # Search the database or solr index for protocols.
  # @param [Hash] options The options of the search.
  # @return [Sunspot::Search::PaginatedCollection, ActiveRecord::Relation] The search results collection.
  def self.search(options = {})
    options.reverse_merge!(paginate: true)
    options.merge!(tags: options[:tags].present? ? options[:tags].split('-') : nil)
    sort = (options[:sort].present? && APPROVED_SORT.include?(options[:sort])) ? options[:sort] : nil
    sort.sub!('title', 'sort_title') if sort.present? && options[:search].present?
    options.merge!(sort: sort)
    if options[:search].present?
      protocols = solr_index_search(options)
    else
      protocols = standard_search(options)
    end
    return protocols
  end

  # Get the protocol facets. A count of tags against protocols in the context of
  # the current search and/or filter.
  # @param [ActiveRecord_Relation, Sunspot::Search::PaginatedCollection] protocols The protocols to get the facets for.
  # @param [Hash] options The options of the facets.
  def self.facets(protocols, options = {})
    options.reverse_merge!(exclude_zero_count: true, exclude_uncategorized: true)

    # Hack - How to convert this collection better?
    protocols = Protocol.where(id: protocols.map(&:id)) if protocols.is_a? Sunspot::Search::PaginatedCollection

    # Recalculate tag count based on current result set not total result set.
    tags = []
    all_tags = Protocol.tag_counts
    all_tags.each do |tag|
      tag.taggings_count = protocols.tagged_with(tag).count
      tag = tag.becomes(Tag)
      if (!options[:exclude_zero_count] || tag.taggings_count > 0) &&
        (!options[:exclude_uncategorized] || tag.tag_category.present?)
        tags << tag
      end
    end
    parts = tags.partition { |tag| tag.tag_category.nil? }
    tags = parts.last.sort_by { |tag| [tag.tag_category.name, tag.name] }
    tags = tags + parts.first if !options[:exclude_uncategorized]
    tags
  end

  # Fork a protocol. Return the forked protocol object. Note you cannot fork a gist you own.
  # WARNING - Protocol callbacks are skipped.
  # @param [String] gist_id The ID of the Gist we're forking.
  # @param [User] protocol_manager The user who will manage the protocol.
  # @return [Protocol] The new protocol that came from the fork.
  def fork(gist_id, protocol_manager)
    return nil if self.octokit_client.blank? || gist_id.blank? || protocol_manager.blank?
    managed_by = self.users.first
    managed_by_username = managed_by.username if managed_by.present?
    new_gist = self.octokit_client.fork_gist(gist_id)
    if new_gist.present?
      title = format_title("[#{protocol_manager.username}] #{new_gist.description}", managed_by_username)
      response = Net::HTTP.get_response(URI.parse(new_gist.files[PROTOCOL_FILE_NAME].raw_url))
      description = response.code == '200' ? response.body : nil
      protocol_manager = ProtocolManager.create(
        user: protocol_manager,
        protocol: Protocol.new(
          title: title,
          description: description,
          gist_id: new_gist.id,
          tag_list: self.tag_list,
          skip_callbacks: true
        )
      )
      protocol_manager.persisted? ? protocol_manager.protocol : nil
    else
      nil
    end
  end

  # Publish a protocol.
  def publish
    create_and_publish_deposition

    self.workflow_state = :published
    self.save
  end

  # Unpublish a protocol.
  def unpublish
    self.workflow_state = :draft
    self.save
  end

  # Create a GitHub Gist from a protocol.
  def create_gist
    gist = {
      description: self.title,
      public: true,
      files: {
        PROTOCOL_FILE_NAME => {
          content: self.description
        }
      }
    }
    gist = self.octokit_client.create_gist(gist)
    self.gist_id = gist.id
  end

  # Update a GitHub Gist from a protocol.
  def update_gist
    gist = self.octokit_client.gist(self.gist_id)
    gist.description = self.title
    gist.files[PROTOCOL_FILE_NAME].content = self.description
    self.octokit_client.edit_gist(self.gist_id, gist)
  end

  # Destroy a GitHub Gist from a protocol.
  def destroy_gist
    self.octokit_client.delete_gist(self.gist_id)
  end

  # Create a Zenodo deposition and publish it.
  def create_and_publish_deposition
    return if self.deposition_id.present?

    # Create the deposition.
    deposition = create_deposition

    if deposition.present?
      # Add the deposition file.
      deposition_file = create_deposition_file

      # Publish the deposition.
      publish_deposition if deposition_file.present?

      if self.doi.present?
        # Add the DOI badge to the markdown.
        self.description += self.doi_badge
      else
        # Cleanup unless fully published.
        self.deposition_id = nil
      end
    end
  end

  # Create a Zenodo deposition.
  def create_deposition
    deposition_attributes = ZenodoProtocolSerializer.new(protocol: self).as_json
    deposition = Service::DepositionManager.create_deposition(deposition: deposition_attributes)
    self.deposition_id = deposition['id'] unless deposition.blank?
    deposition
  end

  # Add a file to a Zenodo deposition.
  def create_deposition_file
    file = gist_file_raw_url
    if file.present?
      Service::DepositionManager.create_deposition_file(
        deposition_id: self.deposition_id,
        file_or_io: open(file),
        filename: PROTOCOL_FILE_NAME,
        content_type: Mime::Type.lookup_by_extension(:markdown)
      )
    end
  end

  # Publish a Zenodo deposition.
  def publish_deposition
    deposition = Service::DepositionManager.publish_deposition(deposition_id: self.deposition_id)
    self.doi = deposition['doi'] unless deposition.blank?
    deposition
  end

  # Calculate the average rating for this protocol.
  # @return [Float, nil] The average rating for the protocol.
  def average_rating
    return 0 if ratings.size == 0
    ratings.sum(:score) / ratings.size
  end

  private
    # Format a protocol title. Strip the bracketed username for a forked protocol.
    # @param [String] title The title of that we're formatting.
    # @param [String] username The username we're stripping from the string.
    # @return [String] The formatted title.
    def format_title(title, username)
      title.slice! "[#{username}]"
      title
    end

    # Get the file to publish from the Gist.
    # @return [String, nil] The URL of the raw Gist file.
    def gist_file_raw_url
      gist = self.octokit_client.gist(self.gist_id)
      gist.present? ? gist.files[PROTOCOL_FILE_NAME].raw_url : nil
    end

    # Perform a search for protocols against the Solr index.
    # @param [Hash] options The options of the search.
    # @return [Sunspot::Search::PaginatedCollection] The search results collection.
    def self.solr_index_search(options)
      sort = nil
      if options[:sort].present?
        sort = options[:sort].split(' ').map { |x| x.to_sym }
      end
      search = solr_search do
        fulltext options[:search]
        facet :tag_list
        facet :workflow_state
        if sort.present?
          order_by *sort
        end
        if options[:paginate]
          paginate(page: options[:page] || 1, per_page: Protocol.per_page)
        else
          # Solr has no disable pagination so you have to return
          # a single page with all results.
          paginate(page: 1, per_page: Protocol.count)
        end
        options[:tags].each {|tag| with(:tag_list, tag)} if options[:tags].present?
        with(:workflow_state, 'published')
      end
      search.results
    end

    # Perform a search for protocols against the database.
    # @param [Hash] options The options of the search.
    # @return [ActiveRecord::Relation, Array] The search results collection.
    def self.standard_search(options)
      protocols = options[:paginate] ? Protocol.with_published_state.paginate(
        page: options[:page] || 1,
        per_page: Protocol.per_page
      ) : Protocol.with_published_state
      protocols = protocols.tagged_with(options[:tags]) if options[:tags].present?
      protocols = protocols.managed_by(User.find_by_username(options[:u])) if options[:u].present?
      options[:sort].present? ? protocols.reorder(options[:sort].sub('title', 'LOWER(title)::bytea')) : protocols
    end

    # Build a protocol and populate the description field with Markdown
    # converted from the supplied Word file.
    # @param [Http::UploadedFile] uploaded_file The Word file we're converting.
    # @return [Protocol] The new protocol with the description populated.
    def self.build_from_word(uploaded_file:)
      protocol = Protocol.new(description: I18n.t('constants.protocols.template'))
      if WORD_FILE_EXTENSIONS.include?(File.extname(uploaded_file.original_filename))
        markdown_manager = Service::WordToMarkdownManager.new(filepath: uploaded_file.tempfile)
        protocol = Protocol.new(description: markdown_manager.markdown)
      else
        protocol.errors[:base] << I18n.t('errors.models.protocol.invalid_file_format')
      end
      protocol
    end
end
