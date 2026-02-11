class AuthController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]

    @account = Account.from_omniauth(auth, current_user)

    if @account.persisted?
      redirect_to "http://localhost:4200/dashboard?success=true", allow_other_host: true
    else
      render json: { error: "Account can't be saved!" }, status: :unprocessable_entity
    end
  end

  def failure
    redirect_to "http://localhost:4200/dashboard?error=#{params[:message]}", allow_other_host: true
  end
end
