Rails.application.routes.draw do
  resources :teams do
    resources :members, shallow: true
  end
  resources :projects do
    resources :members, only: [:create, :new, :index, :update]
  end
  resources :projects do
    resources :member_projects, only: [:create, :index, :update]
  end
  resources :members, only: [:show, :edit, :update, :destroy, :index]
  resources :projects
  resources :tests
  resources :member_projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
