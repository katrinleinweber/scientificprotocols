require 'spec_helper'

describe Rating do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :protocol }
  end
  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :protocol }
  end
  describe 'scopes' do

  end
end
