class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

  def resource_not_found
    render json: {msg: "Resource not found"}, status: :not_found
  end

  def set_application
    # Raise record not found exception if the provided token doesn't match any of our records
    app_token = params[:application_id] || params[:id]
    @app_redis_key = Application.get_redis_key({app_token: app_token})
    @app = Application.redis_get(@app_redis_key)
    if @app.nil?
      @app = Application.find_by_token!(app_token)
      @app.redis_set
    end
  end

  def set_chat
    chat_number = params[:chat_id] || params[:id]
    @chat_redis_key = Chat.get_redis_key({app_token: @app.token, chat_number: chat_number})
    @chat = Chat.redis_get(@chat_redis_key)
    if @chat.nil?
      @chat = @app.chats.find_by_number!(chat_number)
      @chat.redis_set
    end
  end

  def set_message
    msg_number = params[:id]
    @message_redis_key = Message.get_redis_key({app_token: @app.token, chat_number: @chat.number, msg_number: msg_number})
    @message = Message.redis_get(@message_redis_key)
    if @message.nil?
      @message = @chat.messages.find_by_number!(msg_number)
      @message.redis_set
    end
  end

  # def get_from_cache
  #   app_token = params[:application_id] || params[:id]
  #   redis_key = "app_#{app_token}"
  #   cached_app = Application.redis_get(redis_key)
  # end

end
