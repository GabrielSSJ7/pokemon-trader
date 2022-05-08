class V1::OperationsHistoryController < ApplicationController
  include ::ApplicationHelper

  before_action :authorize_request

  def index
    @operations = OperationHistory::Find.call(@current_user)
    render json: @operations
  end

end
