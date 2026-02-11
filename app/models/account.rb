class Account < ApplicationRecord
  # --- Verbindungen ---
  belongs_to :user
  belongs_to :platform, optional: true
  has_many :stats, dependent: :destroy

  validates :username, presence: true
  # platform_user_id ist die 'uid' von Google/Twitch/Instagram
  validates :platform_user_id, presence: true, uniqueness: { scope: :platform_id }

  def self.from_omniauth(auth, current_user)
    platform_name = case auth.provider
                    when /google/ then "Google"
                    when /twitch/ then "Twitch"
                    when /instagram/ then "Instagram"
                    else auth.provider.capitalize
                    end

    platform = Platform.find_or_create_by(name: platform_name)

    account = current_user.accounts.where(
      platform: platform,
      platform_user_id: auth.uid
    ).first_or_initialize

    account.update!(
      username: auth.info.name || auth.info.nickname || auth.info.email,
      access_token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token || account.refresh_token,
      expires_at: Time.at(auth.credentials.expires_at),
      token_type: auth.credentials.token_type
    )
    account
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def refresh_google_token!
    return unless expired? && refresh_token.present? && platform&.name == "Google"



    response = Faraday.post("https://oauth2.googleapis.com/token", {
      client_id:     ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      refresh_token: refresh_token,
      grant_type:    'refresh_token'
    })

    data = JSON.parse(response.body)

    if response.success?
      update!(
        access_token: data['access_token'],
        expires_at: Time.current + data['expires_in'].seconds
      )
    else
      Rails.logger.error "Google Refresh Error (Account #{id}): #{data}"
    end
  end
end
