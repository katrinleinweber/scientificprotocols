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
  describe 'methods' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:github_user) { FactoryGirl.create(:github_user) }
    describe '#from_omniauth' do
      it 'finds a user by id and provider' do
        expect(User.from_omniauth(github_user)).to eq(github_user)
      end
      it 'does not change existing user email or username' do
        email = github_user.email
        username = github_user.username
        User.from_omniauth(github_user)
        expect(github_user.email).to eq(email)
        expect(github_user.username).to eq(username)
      end
    end
    #TODO - handle auth cases. How to supply auth object?
    describe '#get_unique_username' do
      it 'does not modify a unique username' do
        user = FactoryGirl.build(:user)
        username = User.send(:get_unique_username, user.username)
        expect(username).to eq(user.username)
      end
      it 'modifies a non unique username' do
        username = User.send(:get_unique_username, user.username)
        expect(username).to eq(user.username + '1')
      end
    end
    describe '#github_connected?' do
      it 'returns true if the user has a GitHub account' do
        expect(github_user.github_connected?).to eq(true)
      end
      it 'returns false if the user has no GitHub account' do
        expect(user.github_connected?).to eq(false)
      end
    end
  end
end
