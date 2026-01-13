class AuthController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]

    platform = Platform.find_or_create_by(platform_name: auth.provider)
    account = Account.find_or_initialize_by(
      platform_user_id: auth.uid,
      platform: platform
    )

    account.username = auth.info.name
    account.access_token = auth.credentials.token
    account.refresh_token = auth.credentials.refresh_token
    account.token_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
    account.save!

    redirect_to ENV["FRONTEND_URL"] || "http://localhost:4200/dashboard"
  end

  def failure
    render json: { error: params[:message] }, status: :unauthorized
  end
end
