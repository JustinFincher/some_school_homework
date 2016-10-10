Rails.application.routes.draw do
  resources :users
  resources :records

  resources :users do
    resources :records
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'
end
