class TiktokClient
  def initialize(token)
    @token = token
  end

  def me
    uri = URI("https://open.tiktokapis.com/v2/user/info/?fields=open_id,display_name")
    req = Net::HTTP::Post.new(uri)
    req["Authorization"] = "Bearer #{@token}"

    JSON.parse(Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }.body)
  end
end
