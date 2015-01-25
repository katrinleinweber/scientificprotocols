require 'spec_helper'

describe RatingsController do
  let(:username) { 'dior001' }
  let(:protocol) { create(:protocol) }
  let(:rating) { create(:rating, protocol: protocol) }
  context 'Guest Access' do
    let(:user) { FactoryGirl.create(:user, username: username) }
    describe 'POST #create' do
      it 'redirects to the login page' do
        post :create, protocol_id: protocol.slug, score: 5
        expect(response).to redirect_to '/signup'
      end
    end
    describe 'PATCH #update' do
      it 'redirects to the login page' do
        patch :update, protocol_id: protocol.slug, id: rating.id, score: 5
        expect(response).to redirect_to '/signup'
      end
    end
  end
  context 'Authenticated User' do
    login_user
    let(:user) { FactoryGirl.create(:user, username: username) }
    describe 'POST #create' do
      it 'creates a new rating' do
        expect{ post :create, protocol_id: protocol.slug, score: 5, format: :js }.to change{ Rating.count }.by(1)
      end
    end
    describe 'PATCH #update' do
      it 'forbids access' do
        expect{ patch :update, protocol_id: protocol.slug, id: rating.id, score: 5, format: :js }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
  context 'Rating Owner' do
    login_user
    let(:user) do
      @current_user.update_attribute(:username, username)
      @current_user
    end
    describe 'POST #create' do
      it 'creates a new rating' do
        expect{ post :create, protocol_id: protocol.slug, score: 5, format: :js }.to change{ Rating.count }.by(1)
      end
    end
    describe 'PATCH #update' do
      it 'updates a rating' do
        rating = create(:rating, protocol: protocol, user: user)
        patch :update, protocol_id: protocol.slug, id: rating.id, score: 5, format: :js
        rating.reload
        expect(rating.score).to eq(5)
      end
    end
  end
end
