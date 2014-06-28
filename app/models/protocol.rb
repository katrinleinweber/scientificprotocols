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

  # Get the protocol facets. A count of tags against protocols.
  #
  # @param [Array] tags A list of tags to filter the facets by.
  # @return [Array] An array of facets.
  def self.facets(protocols)
    return Protocol.tag_counts.order(:name) if protocols.blank?
    # Correct the tag count to account for multiple tag selections.
    protocols = Protocol.where(id: protocols.map(&:id))
    protocols.tag_counts.order(:name).each {|tag| tag.taggings_count = protocols.tagged_with(tag).count}
  end
end
