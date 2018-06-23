Rails.application.routes.draw do
  resources :prices
  resources :backstage_props do
    post 'delete_plane_type'
  end
  resources :plane_blueprints
  resources :tickets
  resources :planes
  resources :flights
  resources :users
  resources :tickets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'application#index'

  # get 'analytics#index'
  resources :analytics
end
