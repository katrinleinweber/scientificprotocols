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
    text :tag_list, boost: 2
    string :sort_title do
      title.downcase.gsub(/^(an?|the)\b/, '')
    end
  end
  self.per_page = 10
end
