class TiktokStatsService
  def initialize(account)
    @account = account
    @conn = Faraday.new(url: "https://open.tiktokapis.com/")
  end

  def fetch
    res = @conn.get("video/list") do |req|
      req.params["open_id"] = @account.platform_user_id
      req.headers["Authorization"] = "Bearer #{@account.access_token}"
    end

    videos = JSON.parse(res.body)["data"]["videos"]
    videos.each do |video|
      @account.stats.create!(
        date: Date.today,
        followers: video["stats"]["followers"],
        likes: video["stats"]["digg_count"],
        posts: 1
      )
    end
  end
end
