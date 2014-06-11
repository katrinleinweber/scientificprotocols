Rails.application.routes.draw do
  mount_roboto
  devise_for :users
  root to: 'home#index'
  resources :protocols
  get ':action' => 'static#:action'
  get 'sitemap.xml', to: redirect('http://scientificprotocols.s3-website-us-east-1.amazonaws.com/sitemaps/sitemap.xml.gz')
end
