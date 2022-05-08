class V1::WalletController < ApplicationController
  before_action :authorize_request

  def show
    @wallet = Wallet::Find.call(@current_user)
    render json: @wallet
  end
end
