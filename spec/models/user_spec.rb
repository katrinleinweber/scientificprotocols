require 'spec_helper'

describe User do
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :protocols }
  end
  describe 'validations' do

  end
  describe 'scopes' do

  end
end
