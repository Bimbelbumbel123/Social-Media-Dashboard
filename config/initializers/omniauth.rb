Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           scope: "https://www.googleapis.com/auth/youtube.readonly"

  provider :twitch,
           ENV["TWITCH_CLIENT_ID"],
           ENV["TWITCH_CLIENT_SECRET"],
           scope: "user:read:email"
end
