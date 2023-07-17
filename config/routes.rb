Rails.application.routes.draw do
  resources :comments
  get 'about/index'
  resources :news do
    resources :comments, only: [:create]
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "news#index"

end
