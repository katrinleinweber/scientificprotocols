class Protocol < ActiveRecord::Base
  extend FriendlyId
  attr_accessor :skip_callbacks
  include Octokitable
  include ProtocolObserver
  acts_as_taggable
  friendly_id :title, use: :slugged
  has_many :protocol_managers
  has_many :users, through: :protocol_managers
  default_scope { order('LOWER(title)') }
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

  def self.search(params = {}, options = {})
    options.reverse_merge!({paginate: true})
    tags = params[:tags].present? ? params[:tags].split('-') : nil
    if params[:search].present?
      search = solr_search do
        fulltext params[:search]
        facet :tag_list
        if options[:paginate]
          paginate(page: params[:page] || 1, per_page: Protocol.per_page)
        else
          # Solr has no disable pagination so you have to return a single page with all results.
          paginate(page: 1, per_page: Protocol.count)
        end
        tags.each {|tag| with(:tag_list, tag)} if tags.present?
      end
      protocols = search.results
    else
      protocols = options[:paginate] ? Protocol.paginate(
        page: params[:page] || 1, per_page: Protocol.per_page
      ) : Protocol.all
      protocols = protocols.tagged_with(tags) if tags.present?
      protocols = protocols.managed_by(User.find_by_username(params[:u])) if params[:u].present?
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
    new_gist = self.octokit_client.fork_gist(gist_id)
    if new_gist.present?
      title = "[#{protocol_manager.username}] #{new_gist.description}"
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
end
