Rails.application.routes.draw do
  resources :users
  resources :password_resets, only: [:edit, :update]

  resources :attempts
  resource :session, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :drill_groups do
    resources :questions do
      resources :solutions
    end
  end

  get('/', { to: 'home#index', as: :root })
  get('/sign_up/thanks', { to: 'users#thanks' })
  get('/forgot_password', {to: 'password_resets#forgot_password'})

end
