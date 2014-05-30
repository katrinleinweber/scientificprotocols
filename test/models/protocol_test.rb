require 'test_helper'

class ProtocolTest < ActiveSupport::TestCase
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :users, through: :protocol_managers }
  end
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
  end
end
