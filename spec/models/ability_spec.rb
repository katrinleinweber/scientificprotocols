require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  describe 'abilities' do
    subject(:user) { user }
    let(:any) { [:create, :read, :update, :destroy, :manage] }
    let(:change) { [:update, :destroy, :manage] }
    let(:create_and_change) { [:create] + change }
    let(:options) { [:star, :unstar, :fork, :discussion, :create_comment, :delete_comment] }
    let(:workflow) { [:publish, :unpublish] }
    describe 'on Protocols' do
      context 'for guest user' do
        let(:user) { nil }
        let(:protocol) { FactoryGirl.create(:protocol, :published) }
        let(:draft_protocol) { FactoryGirl.create(:protocol) }
        it { should have_ability([:read, :discussion], for: protocol) }
        it { should_not have_ability(any + options + workflow, for: draft_protocol) }
        it { should_not have_ability(any + options + workflow - [:read, :discussion], for: protocol) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:protocol) { FactoryGirl.create(:protocol, :published) }
        let(:draft_protocol) { FactoryGirl.create(:protocol) }
        it { should have_ability([:read, :create] + options, for: protocol) }
        it { should_not have_ability(change + workflow, for: protocol) }
      end
      context 'for protocol owner' do
        let(:user) { FactoryGirl.create(:user) }
        let(:protocol_manager) { FactoryGirl.create(:protocol_manager, user: user, protocol: create(:protocol, :published)) }
        it { should have_ability(any + options + workflow, for: protocol_manager.protocol) }
      end
    end
    describe 'on Protocol Managers' do
      context 'for guest user' do
        let(:user) { nil }
        let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
        it { should_not have_ability(any, for: protocol_manager) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
        it { should_not have_ability(any, for: protocol_manager) }
      end
      context 'for protocol manager owner' do
        let(:user) { FactoryGirl.create(:user) }
        let(:protocol_manager) { FactoryGirl.create(:protocol_manager, user: user) }
        it { should have_ability(any - [:create], for: protocol_manager) }
        it { should_not have_ability(:create, for: protocol_manager) }
      end
    end
    describe 'on Users' do
      context 'for guest user' do
        let(:user) { nil }
        let(:target_user) { FactoryGirl.create(:user) }
        it { should have_ability(:read, for: target_user) }
        it { should_not have_ability(create_and_change + [:starred], for: target_user) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:target_user) { FactoryGirl.create(:user) }
        it { should have_ability(:read, for: target_user) }
        it { should_not have_ability(create_and_change + [:starred], for: target_user) }
      end
      context 'for user owner' do
        let(:user) { FactoryGirl.create(:user) }
        let(:target_user) { user }
        it { should have_ability((any - [:create]) + [:starred], for: target_user) }
        it { should_not have_ability(:create, for: target_user) }
      end
    end
    describe 'on Ratings' do
      context 'for guest user' do
        let(:user) { nil }
        let(:rating) { FactoryGirl.create(:rating) }
        it { should_not have_ability(any, for: rating) }
      end
      context 'for authenticated user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:rating) { FactoryGirl.create(:rating) }
        it { should have_ability(:create, for: rating) }
        it { should_not have_ability(any - [:create], for: rating) }
      end
      context 'for rating owner' do
        let(:user) { FactoryGirl.create(:user) }
        let(:rating) { create(:rating, user: user) }
        it { should have_ability([:create, :update], for: rating) }
        it { should_not have_ability(any - [:create, :update], for: rating) }
      end
    end
  end
end

