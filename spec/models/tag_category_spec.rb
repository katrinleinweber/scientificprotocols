require 'spec_helper'

describe TagCategory do
  describe 'associations' do
    it { should have_many :tags }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end