class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

  def resource_not_found
    render json: {msg: "Resource not found"}, status: :not_found
  end

  def set_application
    # Raise record not found exception if the provided token doesn't match any of our records
    @app = Application.find_by_token!(params[:id] || params[:application_id])
  end

  def set_chat
    @chat = @app.chats.find_by_number!(params[:id] || params[:chat_id])
  end

  def set_message
    @message = @chat.messages.find_by_numer!(params[:id])
  end

end
