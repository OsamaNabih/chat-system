class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found
  before_action :set_pagination_data

  def resource_not_found
    render json: {msg: "Resource not found"}, status: :not_found
  end

  def set_pagination_data
    @page = params[:page].to_i
    @page = (@page < 1 ? 1 : @page) - 1
    @per_page = ENV.fetch("ITEMS_PER_PAGE", 10).to_i
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
    puts @app
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

  def format_response(response, keys)
    response.to_json(except: keys)
  end
end
