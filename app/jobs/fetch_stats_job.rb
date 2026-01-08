class FetchStatsJob < ApplicationJob
  queue_as :default

  def perform(account_id)
    account = Account.find(account_id)
    case account.platform.platform_name
    when "youtube"
      YoutubeStatsService.new(account).fetch
    end
  end
end
