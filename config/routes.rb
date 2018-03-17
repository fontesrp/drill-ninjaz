Rails.application.routes.draw do
  resources :attempts
  resource :session, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :drill_groups do
    resources :questions do
      resources :solutions
    end
  end

  get('/', { to: 'home#index' })
end
