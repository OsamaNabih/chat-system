class MessagesController < ApplicationController
  # We don't need the app or chat to search for a @message as we have the app_id and chat_number in the URL
  # which are all we need for our ElasticSearch query as they are indexed there
  # Thus saving 2 SELECT queries on the search endpoint
  before_action :set_application, except: [:search_messages] 
  before_action :set_chat, except: [:search_messages]
  before_action :set_message, except: [:index, :create, :search_messages]

  def index
    messages = Chat.connection.select_all("SELECT number, body, created_at, updated_at FROM messages")
    render json: messages
  end

  def show
    render json: @message.as_json.except("id")
  end

  def create
    message_number = self.get_message_number
    message = message_params.merge({number: message_number, chat_id: @chat.id})
    MessageCreationJob.perform_later message
    render json: {msg: "message creation scheduled successfully", number: message_number}, status: :created
  end

  def update 
    if Message.update(@message.id, message_params)
      render json: {msg: "message updated successfully"}, status: :ok
    else
      render json: {msg: "message update failed. Please double check the data provided"}, status: :unprocessable_entity
    end
  end

  def destroy 
    #@message.destroy(@message.id)
    #@chat.update(messages_count: @chat.messages_count - 1)
    render json: {msg: "message destroyed successfully"}, status: :ok
  end

  def search_messages
    # If no search body, return all messages
    search_body = params[:body]
    if search_body.to_s.strip.empty?
      self.index
      return
    end
    # Else search for partial match
    response = @message.search(search_body,
              fields: [:body],
              where: {app_token: params[:application_id], chat_number: params[:chat_id]},
              # load: false, # This fetches data from ES only and doesn't fetch anything from our DB
              match: :text_middle
              )
    results = response.results
    render json: results
  end

  private
    def message_params
      params.require(:message).permit(:body)
    end

    def block_blank_body
      if params[:body].to_s.strip.empty?
        render json: {msg: "message body must not be empty"}, status: :unprocessable_entity
      end
    end

    def get_message_number
      redis_key = "app_#{@app.token}_chat_#{@chat.number}_msg"
      redis_lock_key = redis_key + "_lock"
      lock = $lock_manager.lock(redis_lock_key, 200)
      message_number = $redis.get(redis_key)
      if message_number.nil?
        message_number = (@chat.messages.maximum(:number) || 0) + 1
        $redis.set(redis_key, message_number)
      end
      $redis.incr(redis_key)
      $lock_manager.unlock(lock)
      message_number
    end
end
