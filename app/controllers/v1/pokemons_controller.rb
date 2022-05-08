class V1::PokemonsController < ApplicationController
  include ::ApplicationHelper

  before_action :authorize_request, except: [:index, :show]

  def index
    @pokemons = Pokemon::List.call(
      params[:limit],
      params[:offset]
    )
    render json: @pokemons
  end

  def show
    @pokemon = Pokemon::Find.call(params[:id])
    render json: @pokemon
  end

  def operate
    @result = Pokemon::Operate.call(params[:id], @current_user)
    if @result[:error].present?
      render json: @result, status: :bad_request
    else
      render json: @result
    end
  end
end
