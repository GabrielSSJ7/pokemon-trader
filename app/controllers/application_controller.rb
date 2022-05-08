class ApplicationController < ActionController::API
  include ::ApplicationHelper

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = decode(header)
      @current_user = User.find_by!(_id: @decoded[:user_id][:$oid])
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
