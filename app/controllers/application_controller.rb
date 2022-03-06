class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

  def resource_not_found
    render json: {msg: "Resource not found"}, status: :not_found
  end
end
