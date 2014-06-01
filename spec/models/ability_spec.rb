require 'spec_helper'

describe 'User' do
  describe 'abilities' do
    subject(:user) { FactoryGirl.create(:user) }
    let(:any) { [:create, :read, :update, :destroy, :manage] }
    let(:change) { [:update, :destroy, :manage] }
    let(:create_and_change) { [:create] + change }
    describe 'on Protocols' do
      let(:protocol) { FactoryGirl.create(:protocol) }
      context 'for guest user' do
        let(:user) { nil }
        it { should have_ability(:read, for: protocol) }
        it { should_not have_ability(change, for: protocol) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        it { should have_ability([:read, :create], for: protocol) }
        it { should_not have_ability(change, for: protocol) }
      end
      context 'for protocol owner' do

      end
    end
    describe 'on Protocol Managers' do
      let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
      context 'for guest user' do
        let(:user) { nil }
        it { should have_ability(read, for: protocol_manager) }
        it { should_not have_ability(change, for: protocol_manager) }
      end
      context 'for authenticated user' do
        let(:user) { create(:user) }
        it { should have_ability([:read, :create], for: protocol_manager) }
        it { should_not have_ability(change, for: protocol_manager) }
      end
      context 'for protocol owner' do

      end
    end
    describe 'on Users' do
      let(:target_user) { FactoryGirl.create(:user) }
      context 'for guest user' do
        let(:user) { nil }
        it { should_not have_ability(any, for: target_user) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        it { should_not have_ability(any, for: target_user) }
      end
      context 'for user owner' do

      end
    end
  end
end

