require 'spec_helper'

describe User do
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :protocols }
    it { should have_many :ratings }
  end
  describe 'validations' do
    it { should validate_length_of(:username).is_at_least(1).is_at_most(39) }
    invalid_usernames = ['a.', 'b_', 'c ', 'd)', 'e@']
    invalid_usernames.each do |username|
      it { should_not allow_value(username).for(:username) }
    end
    valid_usernames = ['1', 'a', 'A', 'a-b']
    valid_usernames.each do |username|
      it { should allow_value(username).for(:username) }
    end
  end
  describe 'scopes' do

  end
  describe 'methods' do
    let!(:user) { FactoryGirl.create(:user) }
    describe '#from_omniauth' do
      it 'finds a user by id and provider' do
        expect(User.from_omniauth(user)).to eq(user)
      end
    end
    describe '#starred_protocols' do
      pending 'Implement starred tests'
    end
  end
end
