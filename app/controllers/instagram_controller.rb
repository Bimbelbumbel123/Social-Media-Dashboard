class InstagramController < ApplicationController
  def redirect
    # 
    url = "https://api.instagram.com/oauth/authorize" \
      "?client_id=#{ENV['INSTAGRAM_CLIENT_ID']}" \
      "&redirect_uri=#{ENV['INSTAGRAM_REDIRECT_URI']}" \
      "&scope=user_profile,user_media" \
      "&response_type=code"
    redirect_to url, allow_other_host: true
  end

  def callback
    short_lived_response = Faraday.post("https://api.instagram.com/oauth/access_token") do |req|
      req.body = {
        client_id: ENV["INSTAGRAM_CLIENT_ID"],
        client_secret: ENV["INSTAGRAM_CLIENT_SECRET"],
        grant_type: "authorization_code",
        redirect_uri: ENV["INSTAGRAM_REDIRECT_URI"],
        code: params[:code]
      }
    end

    short_data = JSON.parse(short_lived_response.body)
    access_token = short_data["access_token"]
    user_id = short_data["user_id"]

    long_lived_response = Faraday.get("https://graph.instagram.com/access_token") do |req|
      req.params = {
        grant_type: 'ig_exchange_token',
        client_secret: ENV["INSTAGRAM_CLIENT_SECRET"],
        access_token: access_token
      }
    end

    long_data = JSON.parse(long_lived_response.body)
    final_token = long_data["access_token"] || access_token
    expires_in = long_data["expires_in"] || 3600

    user_info_response = Faraday.get("https://graph.instagram.com/me") do |req|
      req.params = { fields: 'id,username', access_token: final_token }
    end
    username = JSON.parse(user_info_response.body)["username"]

    platform = Platform.find_or_create_by(name: "Instagram")
    account = current_user.accounts.find_or_initialize_by(
      platform: platform,
      platform_user_id: user_id.to_s
    )

    account.update!(
      username: username,
      access_token: final_token,
      token_expires_at: Time.current + expires_in.to_i.seconds
    )

    redirect_to "http://localhost:4200/dashboard?success=instagram", allow_other_host: true
  end
end
