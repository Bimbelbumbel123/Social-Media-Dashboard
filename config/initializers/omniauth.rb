Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           scope: [ "email", "profile", "https://www.googleapis.com/auth/youtube.readonly" ].join(" "),
           access_type: "offline",
           prompt: "consent"

  provider :twitch,
           ENV["TWITCH_CLIENT_ID"],
           ENV["TWITCH_CLIENT_SECRET"],
           scope: "user:read:email"

end
