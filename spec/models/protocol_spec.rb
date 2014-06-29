require 'spec_helper'

describe Protocol do
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :users }
  end
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
  end
  describe 'scopes' do

  end
end
