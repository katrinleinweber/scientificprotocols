Rails.application.routes.draw do
  mount_roboto
  root to: 'home#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  resources :protocols do
    collection do
      get :tags
    end
  end
  resources :users, except: :index
  get 'sitemap.xml', to: redirect('https://s3.amazonaws.com/scientificprotocols/sitemaps/sitemap.xml.gz')
  get ':action' => 'static#:action'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :protocols, only: [:index, :show]
    end
  end
end
