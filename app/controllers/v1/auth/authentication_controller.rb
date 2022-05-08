class V1::Auth::AuthenticationController < ApplicationController
  include ::ApplicationHelper

  def login
    @user = User.where(username: params[:username]).first
    if @user&.authenticate(params[:password])
      token = encode(user_id: @user.id)
      render json: { token: token, username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end 
end
