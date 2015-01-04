class TagCategory < ActiveRecord::Base
  has_many :tags
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end