module Api
  module V1
    class DashboardController < ApplicationController
      before_action :authenticate_user!

      def index
        accounts = current_user.accounts.includes(:platform, :stats)

        render json: accounts.map { |acc|
          latest_stat = acc.stats.order(date: :desc).first

          {
            id: acc.id,
            username: acc.username,
            platform: acc.platform&.name || "Unknown",
            platform_icon: acc.platform&.icon_url,
            current_followers: latest_stat&.followers || 0,
            current_likes: latest_stat&.likes || 0,
            chart_data: acc.stats.order(date: :desc).limit(7).reverse.map do |stat|
              {
                date: stat.date.strftime("%d.%m."),
                followers: stat.followers,
                likes: stat.likes
              }
            end
          }
        }
      end

      private

      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end

      def authenticate_user!
        unless current_user
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end
