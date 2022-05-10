class V1::UsersController < ApplicationController

  before_action :authorize_request, only: [:pokemons]

  def create 
    @user = User.create!(user_params)
    render json: @user, status: :created
  end

  def pokemons
    @pokemons = Pokemon::ListPokemonsUser.call(@current_user)
    render json: @pokemons, status: :ok
  end

  private
  
  def user_params
    {
      :name => params[:name],
      :username => params[:username],
      :password => params[:password]
    }
  end

end
