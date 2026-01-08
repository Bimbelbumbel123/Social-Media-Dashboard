Rails.application.routes.draw do
  resources :accounts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # OmniAuth Login for YouTube & Twitch
  get "/auth/:provider/callback", to: "auth#callback"
  get "/auth/failure", to: "auth#failure"

  # Manual TikTok OAuth
  get "/auth/tiktok", to: "tiktok#redirect"
  get "/auth/tiktok/callback", to: "tiktok#callback"

  # Manual Instagram OAuth
  get "/auth/instagram", to: "instagram#redirect"
  get "/auth/instagram/callback", to: "instagram#callback"

  # Dashboard API
  namespace :api do
    namespace :v1 do
      get "/dashboard", to: "dashboard#index"
    end
  end

end
