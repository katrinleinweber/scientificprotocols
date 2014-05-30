Rails.application.routes.draw do
  mount_roboto
  devise_for :users
  root to: 'home#index'
  resources :protocols
  get ':action' => 'static#:action'
end
