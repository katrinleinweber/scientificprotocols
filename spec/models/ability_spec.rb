require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  describe 'abilities' do
    subject(:user) { user }
    let(:any) { [:create, :read, :update, :destroy, :manage] }
    let(:change) { [:update, :destroy, :manage] }
    let(:create_and_change) { [:create] + change }
    describe 'on Protocols' do
      context 'for guest user' do
        let(:user) { nil }
        let(:protocol) { FactoryGirl.create(:protocol) }
        it { should have_ability(:read, for: protocol) }
        it { should_not have_ability(change, for: protocol) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:protocol) { FactoryGirl.create(:protocol) }
        it { should have_ability([:read, :create], for: protocol) }
        it { should_not have_ability(change, for: protocol) }
      end
      context 'for protocol owner' do

      end
    end
    describe 'on Protocol Managers' do
      context 'for guest user' do
        let(:user) { nil }
        let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
        it { should have_ability(:read, for: protocol_manager) }
        it { should_not have_ability(change, for: protocol_manager) }
      end
      context 'for authenticated user' do
        let(:user) { create(:user) }
        let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
        it { should have_ability([:read, :create], for: protocol_manager) }
        it { should_not have_ability(change, for: protocol_manager) }
      end
      context 'for protocol owner' do

      end
    end
    describe 'on Users' do
      context 'for guest user' do
        let(:user) { nil }
        let(:target_user) { FactoryGirl.create(:user) }
        it { should_not have_ability(any, for: target_user) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:target_user) { FactoryGirl.create(:user) }
        it { should_not have_ability(any, for: target_user) }
      end
      context 'for user owner' do

      end
    end
  end
end

