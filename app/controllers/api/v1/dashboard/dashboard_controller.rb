class Api::V1::Dashboard::DashboardController < ApplicationController
  module Api
    module V1
      class DashboardController < ApplicationController
        def index
          user = User.find(params[:user_id])
          accounts = user.accounts.includes(:platform, :stats)

          render json: accounts.as_json(
            include: { platform: {}, stats: {} },
            methods: [ :latest_stat ]
          )
        end
      end
    end
  end
end
