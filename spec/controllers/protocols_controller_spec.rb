require 'spec_helper'

describe ProtocolsController do
  context 'Guest Access' do
    let(:protocol) { FactoryGirl.create(:protocol) }
    describe 'GET #index' do
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: protocol.id
        expect(response).to render_template :show
      end
    end
    describe 'GET #new' do
      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'POST #create' do
      it 'redirects to the login page' do
        post :create, protocol: FactoryGirl.attributes_for(:protocol)
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'GET #edit' do
      it 'redirects to the login page' do
        get :edit, id: protocol.id
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'PATCH #update' do
      it 'redirects to the login page' do
        patch :update, id: protocol.id, protocol: { title: Faker::Lorem.sentence(5) }
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'DELETE #destroy' do
      it 'redirects to the login page' do
        delete :destroy, id: protocol.id
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'GET #tags' do
      it 'allows access' do
        get :tags, format: :json
        expect(response.code).to eq('200')
      end
    end
    describe 'PUT #star' do
      it 'redirects to the login page' do
        put :star, id: protocol.id
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'DELETE #unstar' do
      it 'redirects to the login page' do
        delete :unstar, id: protocol.id
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'POST #fork' do
      it 'redirects to the login page' do
        post :fork, id: protocol.id
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'GET #discussion' do
      it 'allows access' do
        get :discussion, id: protocol.id
        expect(response).to render_template :discussion
      end
    end
    describe 'POST #create_comment' do
      it 'redirects to the login page' do
        post :create_comment, id: protocol.id, body: Faker::Lorem.words(20)
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'DELETE #delete_comment' do
      it 'redirects to the login page' do
        delete :delete_comment, id: protocol.id, comment_id: 1
        expect(response).to redirect_to '/signup'
      end
    end
  end
  context 'Authenticated User' do
    login_user
    let(:protocol) { FactoryGirl.create(:protocol) }
    describe 'GET #index' do
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: protocol.id
        expect(response).to render_template :show
      end
    end
    describe 'GET #new' do
      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end
    describe 'POST #create' do
      it 'creates a new protocol' do
        expect{ post :create, protocol: FactoryGirl.attributes_for(:protocol) }.to change{ Protocol.count }.by(1)
      end
    end
    describe 'GET #edit' do
      it 'forbids access' do
        expect{ get :edit, id: protocol.id }.to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'PATCH #update' do
      it 'forbids access' do
        expect{
          patch :update, id: protocol.id, protocol: { title: Faker::Lorem.sentence(5) }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'DELETE #destroy' do
      it 'forbids access' do
        expect{ delete :destroy, id: protocol.id }.to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'GET #tags' do
      it 'allows access' do
        get :tags, format: :json
        expect(response.code).to eq('200')
      end
    end
    describe 'PUT #star' do
      it 'redirects to the protocols page' do
        put :star, id: protocol.id
        expect(response).to redirect_to protocol
      end
    end
    describe 'DELETE #unstar' do
      it 'redirects to the protocols page' do
        delete :unstar, id: protocol.id
        expect(response).to redirect_to protocol
      end
    end
    describe 'POST #fork' do
      login_user(Rails.configuration.api_github_2)
      it 'forks a protocol' do
        protocol
        expect{ post :fork, id: protocol.id, protocol: protocol }.to change{ Protocol.count }.by(1)
      end
    end
    describe 'GET #discussion' do
      it 'allows access' do
        get :discussion, id: protocol.id
        expect(response).to render_template :discussion
      end
    end
    describe 'POST #create_comment' do
      it 'redirects to the discussion page' do
        post :create_comment, id: protocol.id, body: Faker::Lorem.words(20)
        expect(response).to redirect_to discussion_protocol_path(protocol)
      end
    end
    describe 'DELETE #delete_comment' do
      it 'redirects to the login page' do
        post :create_comment, id: protocol.id, body: Faker::Lorem.words(20)
        delete :delete_comment, id: protocol.id
        expect(response).to redirect_to discussion_protocol_path(protocol)
      end
    end
  end
  context 'Protocol Manager' do
    login_user
    let(:protocol_manager) { FactoryGirl.create(:protocol_manager, user: @current_user) }
    let(:protocol) { protocol_manager.protocol }
    describe 'GET #index' do
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: protocol.id
        expect(response).to render_template :show
      end
    end
    describe 'GET #new' do
      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end
    describe 'POST #create' do
      it 'creates a new protocol' do
        expect{ post :create, protocol: FactoryGirl.attributes_for(:protocol) }.to change{ Protocol.count }.by(1)
      end
    end
    describe 'GET #edit' do
      it 'renders the :edit template' do
        get :edit, id: protocol.id
        expect(response).to render_template :edit
      end
    end
    describe 'PATCH #update' do
      it 'redirects to the show page' do
        patch :update, id: protocol.id, protocol: { title: Faker::Lorem.sentence(5) }
        expect(response).to redirect_to protocol
      end
      it 'updates a protocol' do
        new_title = Faker::Lorem.sentence 5
        patch :update, id: protocol.id, protocol: { title: new_title }
        protocol.reload
        expect(protocol.title).to eq(new_title)
      end
    end
    describe 'DELETE #destroy' do
      it 'redirects to the protocols page' do
        delete :destroy, id: protocol.id
        expect(response).to redirect_to protocols_url
      end
      it 'deletes a protocol' do
        new_protocol = FactoryGirl.create(:protocol_manager, user: @current_user).protocol
        expect{
          delete :destroy, id: new_protocol.id
        }.to change{ Protocol.count }.by(-1)
      end
    end
    describe 'GET #tags' do
      it 'allows access' do
        get :tags, format: :json
        expect(response.code).to eq('200')
      end
    end
    describe 'PUT #star' do
      it 'redirects to the protocols page' do
        put :star, id: protocol.id
        expect(response).to redirect_to protocol
      end
    end
    describe 'DELETE #unstar' do
      it 'redirects to the protocols page' do
        delete :unstar, id: protocol.id
        expect(response).to redirect_to protocol
      end
    end
    describe 'POST #fork' do
      login_user(Rails.configuration.api_github_2)
      it 'forks a protocol' do
        protocol
        expect{ post :fork, id: protocol.id, protocol: protocol }.to change{ Protocol.count }.by(1)
      end
    end
    describe 'GET #discussion' do
      it 'allows access' do
        get :discussion, id: protocol.id
        expect(response).to render_template :discussion
      end
    end
    describe 'POST #create_comment' do
      it 'redirects to the discussion page' do
        post :create_comment, id: protocol.id, body: Faker::Lorem.words(20)
        expect(response).to redirect_to discussion_protocol_path(protocol)
      end
    end
    describe 'DELETE #delete_comment' do
      it 'redirects to the login page' do
        post :create_comment, id: protocol.id, body: Faker::Lorem.words(20)
        delete :delete_comment, id: protocol.id
        expect(response).to redirect_to discussion_protocol_path(protocol)
      end
    end
  end
end
