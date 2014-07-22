require 'spec_helper'

describe Api::V1::ProtocolsController do
  context "No auth token" do
    let(:protocol){ FactoryGirl.create(:protocol) }
    describe 'GET /api/v1/#index' do
      it 'responds with 200' do
        get :index, format: :json
        expect(response.code).to eq('200')
      end
      it 'responds with an array of protocols' do
        get :index, format: :json
        expect(response.map(&:slug)).to include(protocol.slug)
      end
    end
    describe 'GET /api/v1/#index' do
    end
  end
end