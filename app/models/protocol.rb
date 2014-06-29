class Protocol < ActiveRecord::Base
  extend FriendlyId
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
    facet_tags = []
    protocols.each do |protocol|
      facet_tags = (facet_tags + protocol.tag_list).uniq
    end
    facets = ActsAsTaggableOn::Tag.where(name: facet_tags).order(:name)
    facets.each do |tag|
      tag_count = 0
      protocols.each do |protocol|
        if protocol.tag_list.include?(tag.name)
          tag_count = tag_count + 1
        end
      end
      tag.taggings_count = tag_count
    end
  end
end
