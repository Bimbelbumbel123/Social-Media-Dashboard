class TiktokController < ApplicationController
  # before_action :authenticate_user!

  def redirect
    session[:oauth_state] = SecureRandom.hex(16)

    url = "https://www.tiktok.com/v2/auth/authorize/?" + {
      client_key: ENV["TIKTOK_CLIENT_KEY"],
      scope: "user.info.basic,user.info.stats", # Mehr Rechte für das Dashboard
      response_type: "code",
      redirect_uri: callback_url,
      state: session[:oauth_state]
    }.to_query

    redirect_to url, allow_other_host: true
  end

  def callback
    return redirect_to "http://localhost:4200/dashboard?error=invalid_state" if params[:state] != session[:oauth_state]

    response_data = exchange_code_for_token(params[:code])

    token_data = response_data["data"] || response_data

    if token_data["access_token"]
      platform = Platform.find_or_create_by!(name: "Tiktok")

      account = current_user.accounts.find_or_initialize_by(
        platform: platform,
        platform_user_id: token_data["open_id"]
      )

      account.update!(
        access_token: token_data["access_token"],
        refresh_token: token_data["refresh_token"],
        token_expires_at: Time.current + token_data["expires_in"].to_i.seconds,
        username: "TikTok User"
      )

      redirect_to "http://localhost:4200/dashboard?success=tiktok", allow_other_host: true
    else
      redirect_to "http://localhost:4200/dashboard?error=tiktok_auth_failed", allow_other_host: true
    end
  end

  private

  def callback_url
    ENV["TIKTOK_REDIRECT_URI"] || "http://localhost:3000/auth/tiktok/callback"
  end

  def exchange_code_for_token(code)
    # 
    uri = URI("https://open.tiktokapis.com/v2/oauth/token/")

    res = Net::HTTP.post_form(uri, {
      client_key: ENV["TIKTOK_CLIENT_KEY"],
      client_secret: ENV["TIKTOK_CLIENT_SECRET"],
      code: code,
      grant_type: "authorization_code",
      redirect_uri: callback_url
    })

    JSON.parse(res.body)
  end
end
