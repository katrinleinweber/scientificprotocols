require 'spec_helper'

describe Protocol do
  describe 'associations' do
    it { should have_many :protocol_managers }
    it { should have_many :users }
  end
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
  end
  describe 'scopes' do
    describe '#managed_by' do
      it 'returns a valid set of results' do
        expect(Protocol.managed_by(create(:protocol_manager).user).count).to eq(1)
        expect(Protocol.managed_by(create(:user)).count).to eq(0)
      end
    end
  end
  describe 'class methods' do
    describe '#search' do
      pending 'Implement search tests'
    end
    describe '#facets' do
      let!(:protocol) { create(:protocol) }
      it 'returns a list of tag counts' do
        expect(Protocol.facets(Protocol.all).count).to eq(Protocol.tag_counts.count)
      end
    end
  end
  describe 'instance methods' do
    let(:protocol_manager) { create(:protocol_manager) }
    let(:protocol) { protocol_manager.protocol }
    describe '#format_title' do
      it 'strips the bracketed username from the title' do
        username = protocol_manager.user.username
        protocol.title = "[#{username}] #{Faker::Lorem.words(5)}"
        expect(protocol.send(:format_title, protocol.title, username).include?(username)).to eq(false)
      end
      it 'does not alter the title when bracketed username not present' do
        username = protocol_manager.user.username
        expect(protocol.send(:format_title, protocol.title, username)).to eq(protocol.title)
      end
    end
  end
end
