require 'test_helper'

class UserTest < ActiveSupport::TestCase
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :protocols, through: :protocol_managers }
  end
  describe 'validations' do

  end
end
