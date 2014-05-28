class ProtocolManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :protocol
  accepts_nested_attributes_for :protocol, allow_destroy: true
end