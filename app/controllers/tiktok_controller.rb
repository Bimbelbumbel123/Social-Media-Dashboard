require 'securerandom'
require 'digest'
require 'base64'

class TiktokController < ApplicationController
  # before_action :authenticate_user!

  def redirect
    client_key = ENV["TIKTOK_CLIENT_KEY"]

    # Debug-Check: Falls der Key leer ist, bricht Rails hier mit Fehlermeldung ab
    raise "TIKTOK_CLIENT_KEY is missing! Check your .env file." if client_key.blank?

    # PKCE Logik...
    code_verifier = SecureRandom.hex(32)
    session[:tiktok_code_verifier] = code_verifier
    binary_hash = Digest::SHA256.digest(code_verifier)
    code_challenge = Base64.urlsafe_encode64(binary_hash).gsub(/=/, '')
    session[:oauth_state] = SecureRandom.hex(16)

    url = "https://www.tiktok.com/v2/auth/authorize/?" + {
      client_key: client_key, # Hier muss der korrekte Key stehen
      scope: "user.info.basic",
      response_type: "code",
      redirect_uri: callback_url,
      state: session[:oauth_state],
      code_challenge: code_challenge,
      code_challenge_method: "S256"
    }.to_query

    redirect_to url, allow_other_host: true
  end

  def callback
    # State Validierung
    if params[:state] != session[:oauth_state]
      return redirect_to "http://localhost:4200/dashboard?error=invalid_state", allow_other_host: true
    end

    response_data = exchange_code_for_token(params[:code])
    token_data = response_data["data"] || response_data

    if token_data["access_token"]
      platform = Platform.find_or_create_by!(platform_name: "tiktok")

      # Falls current_user noch nicht existiert (Testphase), Account trotzdem finden/erstellen
      # Idealerweise: current_user.accounts...
      account = Account.find_or_initialize_by(
        platform: platform,
        platform_user_id: token_data["open_id"]
      )

      account.update!(
        access_token: token_data["access_token"],
        refresh_token: token_data["refresh_token"],
        token_expires_at: Time.current + token_data["expires_in"].to_i.seconds,
        username: token_data["display_name"] || "TikTok User"
      )

      redirect_to "http://localhost:4200/dashboard?success=tiktok", allow_other_host: true
    else
      # Hier geben wir den Fehler aus der API zur Notiz aus
      Rails.logger.error "TikTok Auth Error: #{response_data}"
      redirect_to "http://localhost:4200/dashboard?error=tiktok_auth_failed", allow_other_host: true
    end
  end

  private

  def callback_url
    ENV["TIKTOK_REDIRECT_URI"] || "http://localhost:3001/auth/tiktok/callback"
  end

  def exchange_code_for_token(code)
    uri = URI("https://open.tiktokapis.com/v2/oauth/token/")

    # PKCE: Wir müssen den Verifier aus der Session mitschicken
    params = {
      client_key: ENV["TIKTOK_CLIENT_KEY"],
      client_secret: ENV["TIKTOK_CLIENT_SECRET"],
      code: code,
      grant_type: "authorization_code",
      redirect_uri: callback_url,
      code_verifier: session[:tiktok_code_verifier]
    }

    # TikTok API v2 verlangt oft Content-Type: application/x-www-form-urlencoded
    res = Net::HTTP.post_form(uri, params)
    JSON.parse(res.body)
  end
end
