Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :drill_groups do

    get '/questions/start', to: 'questions#start_group', as: :questions_start
    get '/questions/finish', to: 'questions#finish_group', as: :questions_finish
    post '/questions/:id/answer', to: 'questions#answer', as: :question_answer
    get '/questions/:id/next', to: 'questions#next', as: :question_next

    resources :questions do
      resources :solutions
    end
  end
end
