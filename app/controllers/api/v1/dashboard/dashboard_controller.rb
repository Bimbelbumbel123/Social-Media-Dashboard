# app/controllers/api/v1/dashboard_controller.rb
module Api
  module V1
    class DashboardController < ApplicationController
      def index
        accounts = Account.includes(:platform, :stats).all

        render json: accounts.map { |acc|
          {
            id: acc.id,
            username: acc.username,
            platform: acc.platform&.platform_name,
            platform_icon: acc.platform&.icon_url,
            likes: acc.likes,
            clicks: acc.clicks,
            comments: acc.comments,
            dislikes: acc.dislikes,
            posts_count: acc.posts_count,
            recent_stats: acc.stats.order(date: :desc).limit(7).map do |stat|
              {
                date: stat.date.strftime("%Y-%m-%d"),
                followers: stat.followers,
                likes: stat.likes,
                posts: stat.posts
              }
            end
          }
        }
      end
    end
  end
end
