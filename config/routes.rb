Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/:provider/callback", to: "auth#callback"
  get "/auth/failure", to: "auth#failure"

  get "/auth/tiktok", to: "tiktok#redirect"
  get "/auth/tiktok/callback", to: "tiktok#callback"

  namespace :api do
    namespace :v1 do
      get "/dashboard", to: "dashboard#index"

      resources :accounts, only: [:index, :destroy] do
        resources :stats, only: [:index]
      end
    end
  end
end
