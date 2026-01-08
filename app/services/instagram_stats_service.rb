class InstagramStatsService
  def initialize(account)
    @account = account
    @conn = Faraday.new(url: "https://graph.instagram.com")
  end

  def fetch
    res = @conn.get("#{@account.platform_user_id}") do |req|
      req.params["fields"] = "followers_count,media_count"
      req.params["access_token"] = @account.access_token
    end

    data = JSON.parse(res.body)
    @account.stats.create!(
      date: Date.today,
      followers: data["followers_count"],
      posts: data["media_count"],
      likes: 0
    )
  end
end
