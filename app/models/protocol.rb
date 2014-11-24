class Protocol < ActiveRecord::Base
  extend FriendlyId
  attr_accessor :skip_callbacks
  include Octokitable
  include Gistable
  include ProtocolObserver
  acts_as_taggable
  friendly_id :title, use: :slugged
  has_many :protocol_managers
  has_many :users, through: :protocol_managers
  default_scope { order('LOWER(title)::bytea') }
  scope :managed_by, -> (user) { joins(:protocol_managers).where(protocol_managers: { user: user }) }
  validates :title, presence: true
  validates :description, presence: true
  searchable do
    text :title, boost: 5
    text :description
    time :created_at
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
  def self.facets(protocols)
    # Hack - How to convert this collection better?
    protocols = Protocol.where(id: protocols.map(&:id)) if protocols.is_a? Sunspot::Search::PaginatedCollection

    # Recalculate tag count based on current result set not total result set.
    tags = []
    all_tags = Protocol.tag_counts.order(:name)
    all_tags.each do |tag|
      tag.taggings_count = protocols.tagged_with(tag).count
      tags << tag if tag.taggings_count > 0
    end
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

  private
    # Format a protocol title. Strip the bracketed username for a forked protocol.
    # @param [String] title The title of that we're formatting.
    # @param [String] username The username we're stripping from the string.
    # @return [String] The formatted title.
    def format_title(title, username)
      title.slice! "[#{username}]"
      title
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
      end
      search.results
    end

    # Perform a search for protocols against the database.
    # @param [Hash] options The options of the search.
    # @return [ActiveRecord::Relation, Array] The search results collection.
    def self.standard_search(options)
      protocols = options[:paginate] ? Protocol.paginate(
        page: options[:page] || 1,
        per_page: Protocol.per_page
      ) : Protocol.all
      protocols = protocols.tagged_with(options[:tags]) if options[:tags].present?
      protocols = protocols.managed_by(User.find_by_username(options[:u])) if options[:u].present?
      options[:sort].present? ? protocols.reorder(options[:sort].sub('title', 'LOWER(title)::bytea')) : protocols
    end
end
