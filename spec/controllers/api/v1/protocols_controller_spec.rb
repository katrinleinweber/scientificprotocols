require 'spec_helper'

describe Api::V1::ProtocolsController do
  context 'No auth token' do
    let(:protocol) { FactoryGirl.create(:protocol) }
    describe 'GET /api/v1/#index' do
      it 'responds with 200' do
        get :index, format: :json
        expect(response.code).to eq('200')
      end
    end
    describe 'GET /api/v1/#show' do
      it 'responds with 200' do
        get :show, id: protocol.slug, format: :json
        expect(response.code).to eq('200')
      end
      it 'not allowing ids, slugs only' do
          get :show, id: protocol.id, format: :json
          expect(JSON.parse(response.body)).to eq({
            'error' => 'internal_server_error',
            'debug_message' => 'ActiveRecord::RecordNotFound',
          })
      end
    end
  end
end