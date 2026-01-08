# app/controllers/tiktok_controller.rb
class TiktokController < ApplicationController
  def redirect
    redirect_to "https://www.tiktok.com/v2/auth/authorize/?" \
                  "client_key=#{ENV['TIKTOK_CLIENT_KEY']}" \
                  "&scope=user.info.basic,video.list" \
                  "&response_type=code" \
                  "&redirect_uri=#{ENV['TIKTOK_REDIRECT_URI']}"
  end

  def callback
    response = Faraday.post("https://open.tiktokapis.com/v2/oauth/token/") do |req|
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = {
        client_key: ENV["TIKTOK_CLIENT_KEY"],
        client_secret: ENV["TIKTOK_CLIENT_SECRET"],
        code: params[:code],
        grant_type: "authorization_code",
        redirect_uri: ENV["TIKTOK_REDIRECT_URI"]
      }
    end

    data = JSON.parse(response.body)["data"]
    platform = Platform.find_or_create_by(platform_name: "tiktok")
    account = Account.find_or_initialize_by(platform_user_id: data["open_id"], platform: platform)

    account.username = data["union_id"]
    account.access_token = data["access_token"]
    account.refresh_token = data["refresh_token"]
    account.token_expires_at = Time.now + data["expires_in"].to_i.seconds
    account.save!

    redirect_to "/dashboard"
  end
end
