module V1
  class UsersController < ApplicationController

    def create 
      @user = User.create!(user_params)
      render json: @user, status: :created
    end

    private
    
    def user_params
      {
        :name => params[:name],
        :username => params[:username],
        :password_digest => params[:password]
      }
    end

  end
end
