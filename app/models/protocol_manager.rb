class ProtocolManager < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :protocol, touch: true
  accepts_nested_attributes_for :protocol, allow_destroy: true
end