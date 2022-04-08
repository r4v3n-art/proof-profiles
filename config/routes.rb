Rails.application.routes.draw do
  root 'sessions#index'

  resource :sessions, only: :create
  resources :users, only: [:index, :show]
end
