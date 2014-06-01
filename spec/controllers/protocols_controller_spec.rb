require 'spec_helper'

describe ProtocolsController do
  context 'Guest Access' do
    let(:protocol) { FactoryGirl.create(:protocol) }
    describe 'GET #index' do
      it 'renders the :index template' do
        expect{ get :index }.to render_template :index
      end
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        expect{ get :show, id: protocol.id }.to render_template :show
      end
    end
    describe 'GET #new' do
      it 'redirects to the login page' do
        expect{ get :new }.to redirect_to new_user_session_url
      end
    end
    describe 'POST #create' do
      it 'redirects to the login page' do
        expect{ post :create, protocol: protocol }.to redirect_to new_user_session_url
      end
    end
    describe 'GET #edit' do
      it 'redirects to the login page' do
        expect{ get :edit, id: protocol.id }.to redirect_to new_user_session_url
      end
    end
    describe 'PATCH #update' do
      it 'redirects to the login page' do
        expect{ patch :update, id: protocol.id, protocol: protocol }.to redirect_to new_user_session_url
      end
    end
    describe 'DELETE #destroy' do
      it 'redirects to the login page' do
        expect{ delete :destroy, id: protocol.id }.to redirect_to new_user_session_url
      end
    end
  end
  context 'Authenticated User' do
    login_user
    let(:protocol) { FactoryGirl.create(:protocol) }
    describe 'GET #index' do
      it 'renders the :index template' do
        expect{ get :index }.to render_template :index
      end
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        expect{ get :show, id: protocol.id }.to render_template :show
      end
    end
    describe 'GET #new' do
      it 'renders the :new template' do
        expect{ get :new }.to render_template :new
      end
    end
    describe 'POST #create' do
      it 'renders the :show template' do
        expect{ post :create, protocol: protocol }.to redirect_to protocol
      end
      it 'creates a new protocol' do
        expect{ post :create, protocol: protocol }.to change{ Protocol.count }.from(0).to(1)
      end
    end
    describe 'GET #edit' do
      it 'forbids access' do
        expect{ get :edit, id: protocol.id }.to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'PATCH #update' do
      it 'forbids access' do
        expect{ patch :update, id: protocol.id, protocol: protocol }.to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'DELETE #destroy' do
      it 'forbids access' do
        expect{ delete :destroy, id: protocol.id }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
  context 'Protocol Manager' do
    login_user
    let(:protocol_manager) { FactoryGirl.create(:protocol_manager, user: @current_user) }
    let(:protocol) { protocol_manager.protocol }
    describe 'GET #index' do
      it 'renders the :index template' do
        expect{ get :index }.to render_template :index
      end
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        expect{ get :show, id: protocol.id }.to render_template :show
      end
    end
    describe 'GET #new' do
      it 'renders the :new template' do
        expect{ get :new }.to render_template :new
      end
    end
    describe 'POST #create' do
      it 'redirects to the show page' do
        expect{ post :create, protocol: protocol }.to redirect_to protocol
      end
      it 'creates a new protocol' do
        expect{ post :create, protocol: protocol }.to change{ Protocol.count }.from(0).to(1)
      end
    end
    describe 'GET #edit' do
      it 'renders the :edit template' do
        expect{ get :edit, id: protocol.id }.to render_template :edit
      end
    end
    describe 'PATCH #update' do
      it 'redirects to the show page' do
        expect{ patch :update, id: protocol.id, protocol: protocol }.to redirect_to protocol
      end
      it 'updates a protocol' do
        new_title = Faker::Lorem.sentence 5
        patch :update, id: protocol.id, protocol: attributes_for(:protocol, title: new_title)
        protocol.reload
        expect(protocol.title).to eq(new_title)
      end
    end
    describe 'DELETE #destroy' do
      it 'redirects to the protocols page' do
        expect{ delete :destroy, id: protocol.id }.to redirect_to protocols_url
      end
      it 'deletes a protocol' do
        expect{ delete :destroy, id: protocol.id }.to change{ Protocol.count }.from(1).to(0)
      end
    end
  end
end
