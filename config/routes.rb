Rails.application.routes.draw do
  resources :users
  resources :password_resets, only: [:edit, :update]

  resources :attempts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :drill_groups do
    resources :questions do
      resources :solutions
    end
  end
end
