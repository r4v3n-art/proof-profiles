Rails.application.routes.draw do
  root 'sessions#index'

  resource :sessions, only: [:create, :destroy]
  resources :users, param: :address
end
