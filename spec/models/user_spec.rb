require 'spec_helper'

describe User do
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :protocols }
    it { should have_many :ratings }
  end
  describe 'validations' do

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
