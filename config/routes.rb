Rails.application.routes.draw do
  mount_roboto
  devise_for :users
  root to: 'home#index'
  resources :protocols
  get 'sitemap.xml', to: redirect('https://s3.amazonaws.com/scientificprotocols/sitemaps/sitemap.xml.gz')
  get ':action' => 'static#:action'
end
