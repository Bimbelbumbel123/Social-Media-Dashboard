class YoutubeStatsService
  def initialize(account)
    @account = account
    @conn = Faraday.new(url: "https://www.googleapis.com/youtube/v3")
  end

  def fetch
    res = @conn.get("channels") do |req|
      req.params["part"] = "statistics"
      req.params["mine"] = true
      req.headers["Authorization"] = "Bearer #{@account.access_token}"
    end

    JSON.parse(res.body)["items"].each do |item|
      @account.stats.create!(
        date: Date.today,
        followers: item["statistics"]["subscriberCount"],
        likes: item["statistics"]["likeCount"],
        posts: item["statistics"]["videoCount"]
      )
    end
  end
end
