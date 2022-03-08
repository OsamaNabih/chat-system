class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

  def resource_not_found
    render json: {msg: "Resource not found"}, status: :not_found
  end

  def set_application
    # Raise record not found exception if the provided token doesn't match any of our records
    app_token = params[:application_id] || params[:id]
    redis_key = "app_#{app_token}"
    cached_app = Application.redis_get(redis_key)
    @app = cached_app
    if @app.nil?
      @app = Application.find_by_token!(app_token)
      @app.redis_set
    end 
  end

  def set_chat
    chat_number = params[:chat_id] || params[:id]
    redis_key = "app_#{@app.token}_chat_#{chat_number}"
    cached_chat = Chat.redis_get(redis_key)
    @chat = cached_chat
    if @chat.nil?
      @chat = @app.chats.find_by_number(chat_number)
      @chat.redis_set
    end
  end

  def set_message
    msg_number = params[:id]
    redis_key = "app_#{@app.token}_chat_#{chat_number}_msg_#{msg_number}"
    cached_msg = Message.redis_get(redis_key)
    @msg = cached_msg
    if @msg.nil?
      @msg = @chat.messages.find_by_number(msg_number)
      @msg.redis_set
    end
  end

  def get_from_cache
    app_token = params[:application_id] || params[:id]
    redis_key = "app_#{app_token}"
    cached_app = Application.redis_get(redis_key)
  end

end
