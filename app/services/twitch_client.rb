class TwitchClient
  def initialize(token)
    @token = token
  end

  def me
    get("/users")
  end

  def get(path)
    uri = URI("https://api.twitch.tv/helix#{path}")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{@token}"
    req["Client-Id"] = ENV["TWITCH_CLIENT_ID"]

    JSON.parse(Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }.body)
  end
end
