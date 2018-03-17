Rails.application.routes.draw do

  resources :users
  resources :password_resets, only: [:edit, :update]
end
