require 'spec_helper'

describe Token do
  describe 'associations' do
    it { should belong_to :user }
  end
  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :token }
  end
end
