require 'spec_helper'

describe UsersController do
  let(:username) { 'dior001' }
  context 'Guest Access' do
    let(:user) { FactoryGirl.create(:user, username: username) }
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: user.id
        expect(response).to render_template :show
      end
    end
    describe 'GET #starred' do
      it 'redirects to the login page' do
        get :starred, id: user.id
        expect(response).to redirect_to '/signup'
      end
    end
  end
  context 'Authenticated User' do
    login_user
    let(:user) { FactoryGirl.create(:user, username: username) }
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: user.id
        expect(response).to render_template :show
      end
    end
    describe 'GET #starred' do
      it 'forbids access' do
        expect{ get :starred, id: user.id }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
  context 'User Manager' do
    login_user
    let(:user) do
      @current_user.update_attribute(:username, username)
      @current_user
    end
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: user.id
        expect(response).to render_template :show
      end
    end
    describe 'GET #starred' do
      it 'renders the :starred template' do
        get :starred, id: user.id
        expect(response).to render_template :starred
      end
    end
  end
end