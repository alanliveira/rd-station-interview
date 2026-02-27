require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get '/cart', to: 'carts#show', as: 'cart_show'
  post '/cart', to: 'carts#create', as: 'cart_create'
  put '/cart/add_item', to: 'carts#add_item', as: 'cart_add_item'
  delete '/cart/:product_id', to: 'carts#destroy', as: 'cart_destroy'

  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
