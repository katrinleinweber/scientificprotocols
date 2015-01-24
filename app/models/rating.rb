class Rating < ActiveRecord::Base
  belongs_to :protocol
  belongs_to :user
  validates :user, presence: true
  validates :protocol, presence: true
end
