class MessagesController < ApplicationController
  # We don't need the app or chat to search for a @message as we have the app_id and chat_number in the URL
  # which are all we need for our ElasticSearch query as they are indexed there
  # Thus saving 2 SELECT queries on the search endpoint
  before_action :set_application
  before_action :set_chat
  before_action :set_message, except: [:index, :create, :search_messages]

  def index
    messages = Message.where(chat_id: @chat.id).limit(@per_page).offset(@page*@per_page)
    render json: format_response(messages)
  end

  def show
    render json: format_response(@message)
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
    Message.delete(@message.id)
    Message.searchkick_index.remove(@message)
    Message.redis_clear(@message_redis_key)
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
    response = Message.search(search_body,
              fields: [:body],
              where: {app_token: params[:application_id], chat_number: params[:chat_id]},
              page: @page+1,
              per_page: @per_page,
              match: :text_middle,
              # load: false, # This fetches data from ES only and doesn't fetch anything from our DB
              )
    results = response.results
    render json: format_response(results)
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
      redis_lock_key = @message_redis_key.to_s + "_lock"
      lock = $lock_manager.lock(redis_lock_key, ENV.fetch("REDIS_TIMEOUT", 100).to_i)
      puts "MESSAGE KEY: #{@message_redis_key}"
      next_msg_number_key = @chat_redis_key.to_s + "_next"
      message_number = $redis.get(next_msg_number_key)
      if message_number.nil?
        message_number = (@chat.messages.maximum(:number) || 0) + 1
        $redis.set(@message_redis_key, message_number + 1)
      end
      $lock_manager.unlock(lock)
      message_number.to_i
    end

    def format_response(response)
      super(response, [:id, :chat_id])
    end
end
