Rails.application.routes.draw do
  mount_roboto
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'home#index'
  resources :protocols do
    collection do
      get :tags
    end
  end
  resources :users, only: :show
  get 'sitemap.xml', to: redirect('https://s3.amazonaws.com/scientificprotocols/sitemaps/sitemap.xml.gz')
  get ':action' => 'static#:action'
end
