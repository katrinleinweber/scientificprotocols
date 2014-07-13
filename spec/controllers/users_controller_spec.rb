require 'spec_helper'

describe UsersController do
  context 'Guest Access' do
    let(:user) { FactoryGirl.create(:user) }
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: user.id
        expect(response).to render_template :show
      end
    end
  end
  context 'Authenticated User' do
    login_user
    let(:user) { FactoryGirl.create(:user) }
    describe 'GET #show' do
      it 'renders the :show template' do
        get :show, id: user.id
        expect(response).to render_template :show
      end
    end
  end
end