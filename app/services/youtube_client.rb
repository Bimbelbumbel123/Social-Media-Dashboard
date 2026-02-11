require "google/apis/youtube_v3"

class YoutubeClient
  def initialize(access_token)
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.authorization = access_token
  end

  def my_channel
    @service.list_channels(
      "snippet,statistics",
      mine: true
    )
  end
end
