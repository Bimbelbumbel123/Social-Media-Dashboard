class InstagramClient
  def initialize(token)
    @token = token
  end

  def me
    uri = URI("https://graph.instagram.com/me?fields=id,username,media_count&access_token=#{@token}")
    JSON.parse(Net::HTTP.get(uri))
  end
end
