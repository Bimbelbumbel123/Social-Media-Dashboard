Rails.application.routes.draw do
  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check

  # OmniAuth (YouTube, Twitch)
  # config/routes.rb
  get "/auth/google_oauth2", as: :google_login
  get "/auth/google_oauth2/callback", to: "auth#callback"
  get "/auth/failure", to: "auth#failure"

  get "/auth/:twitch/callback", to: "auth#callback"
  get "/auth/failure", to: "auth#failure"

  # TikTok OAuth
  get "/auth/tiktok", to: "tiktok#redirect"
  get "/auth/tiktok/callback", to: "tiktok#callback"

  # Instagram OAuth
  get "/auth/instagram", to: "instagram#redirect"
  get "/auth/instagram/callback", to: "instagram#callback"

  # Dashboard API
  namespace :api do
    namespace :v1 do
      get "/dashboard", to: "dashboard#index"
    end
  end
end
