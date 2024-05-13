Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      # users
      post "users", to: "users#create"

      # posts
      post 'posts', to: "posts#create"

      # ratings
      post 'ratings', to:"ratings#create"
      get 'ratings/top-rated', to: "ratings#top_posts"
    end
  end
end
