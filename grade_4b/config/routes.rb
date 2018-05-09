Rails.application.routes.draw do
  resources :backstage_props do
    post 'add_plane_type', backstage_prop_id: :id
  end
  resources :plane_blueprints
  resources :tickets
  resources :planes
  resources :flights
  resources :users
  resources :tickets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'application#show'

end
