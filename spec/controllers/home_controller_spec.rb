require 'spec_helper'

describe HomeController do
  context 'Guest Access' do
    describe 'GET #index' do
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
  context 'Authenticated User' do
    login_user
    describe 'GET #index' do
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end
