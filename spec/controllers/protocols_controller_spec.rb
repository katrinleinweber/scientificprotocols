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
        expect(response).to redirect_to new_user_session_url
      end
    end
    describe 'POST #create' do
      it 'redirects to the login page' do
        post :create, protocol: protocol
        expect(response).to redirect_to new_user_session_url
      end
    end
    describe 'GET #edit' do
      it 'redirects to the login page' do
        get :edit, id: protocol.id
        expect(response).to redirect_to new_user_session_url
      end
    end
    describe 'PATCH #update' do
      it 'redirects to the login page' do
        patch :update, id: protocol.id, protocol: protocol
        expect(response).to redirect_to new_user_session_url
      end
    end
    describe 'DELETE #destroy' do
      it 'redirects to the login page' do
        delete :destroy, id: protocol.id
        expect(response).to redirect_to new_user_session_url
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
      it 'renders the :show template' do
        post :create, protocol: protocol
        expect(response).to render_template :show
      end
      it 'creates a new protocol' do
        expect{ post :create, protocol: protocol }.to change{ Protocol.count }.from(0).to(1)
      end
    end
    describe 'GET #edit' do
      it 'forbids access' do
        get :edit, id: protocol.id
        expect(response).to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'PATCH #update' do
      it 'forbids access' do
        patch :update, id: protocol.id, protocol: protocol
        expect(response).to raise_error(CanCan::AccessDenied)
      end
    end
    describe 'DELETE #destroy' do
      it 'forbids access' do
        delete :destroy, id: protocol.id
        expect(response).to raise_error(CanCan::AccessDenied)
      end
    end
  end
  context 'Protocol Owner' do

  end
end