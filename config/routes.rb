Rails.application.routes.draw do
  mount_roboto
  root to: 'home#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  resources :protocols do
    collection do
      get :tags
      post :parse_word_doc
    end
    member do
      patch :publish
      patch :unpublish
      put :star
      delete :unstar
      post :fork
      get :discussion
      post :create_comment
      delete :delete_comment
    end
    resources :ratings, only: [:create, :update]
  end
  resources :users, except: :index do
    member do
      get :starred
    end
  end
  get 'sitemap.xml', to: redirect('https://s3.amazonaws.com/scientificprotocols/sitemaps/sitemap.xml.gz')
  get ':action' => 'static#:action'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :protocols, only: [:index, :show]
    end
  end
end
