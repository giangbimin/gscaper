Rails.application.routes.draw do
  apipie
  devise_for :users
  resources :keywords, only: %i[index new create show] do
    post :refresh
  end
  root 'keywords#index'

  namespace :api do
    post 'sign_in', to: 'authentication#sign_in'
    post 'refresh', to: 'authentication#refresh'
    post 'sign_out', to: 'authentication#sign_out'
    namespace :v1 do
      resources :keywords, only: %i[index create show]
    end

  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end