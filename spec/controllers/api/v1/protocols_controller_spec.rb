require 'spec_helper'

describe Api::V1::ProtocolsController do
  context "No auth token" do
    let(:protocol) { FactoryGirl.create(:protocol) }
    describe 'GET /api/v1/protocols/#index' do
      it 'responds with 200' do
        get :index, format: :json
        expect(response.code).to eq('200')
      end
    end
    describe 'GET /api/v1/protocols/slug/#show' do
      it 'responds with 200' do
        get :show, id: protocol.slug, format: :json
        expect(response.code).to eq('200')
      end
      it 'not allowing ids, slugs only' do
          get :show, id: protocol.id, format: :json
          expect(JSON.parse(response.body)).to eq({
            "error" => "internal_server_error",
            "debug_message" => "ActiveRecord::RecordNotFound",
          })
      end
    end
  end
  context "With Auth Token" do
    let(:token) { FactoryGirl.create(:token) }
    describe 'POST /api/v1/protocols' do
      it 'responds with 200' do
        token_string= "Authorization: Token token='#{token.token}'" 
        request.env["HTTP_AUTHORIZATION"] = token_string
        post :create,
          {:protocol => FactoryGirl.attributes_for(:protocol)},
          {"HTTP_AUTHORIZATION" => token_string
          }
        puts response.inspect
        expect(response.code).to eq('200')
      end
    end
  end  
end