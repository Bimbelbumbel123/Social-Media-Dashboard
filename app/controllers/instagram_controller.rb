# app/controllers/instagram_controller.rb
class InstagramController < ApplicationController
  def redirect
    redirect_to "https://api.instagram.com/oauth/authorize?" \
                  "client_id=#{ENV['INSTAGRAM_CLIENT_ID']}" \
                  "&redirect_uri=#{ENV['INSTAGRAM_REDIRECT_URI']}" \
                  "&scope=user_profile,user_media" \
                  "&response_type=code"
  end

  def callback
    response = Faraday.post("https://api.instagram.com/oauth/access_token") do |req|
      req.body = {
        client_id: ENV["INSTAGRAM_CLIENT_ID"],
        client_secret: ENV["INSTAGRAM_CLIENT_SECRET"],
        grant_type: "authorization_code",
        redirect_uri: ENV["INSTAGRAM_REDIRECT_URI"],
        code: params[:code]
      }
    end

    data = JSON.parse(response.body)
    platform = Platform.find_or_create_by(platform_name: "instagram")
    account = Account.find_or_initialize_by(platform_user_id: data["user_id"], platform: platform)

    account.username = data["user"]["username"]
    account.access_token = data["access_token"]
    account.token_expires_at = Time.now + 60.days
    account.save!

    redirect_to "/dashboard"
  end
end
