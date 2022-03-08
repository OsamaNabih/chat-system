class MessagesController < ApplicationController
  # We don't need the app or chat to search for a message as we have the app_id and chat_number in the URL
  # which are all we need for our ElasticSearch query as they are indexed there
  # Thus saving 2 SELECT queries on the search endpoint
  before_action :set_application, except: [:search_messages] 
  before_action :set_chat, except: [:search_messages]
  before_action :set_message, except: [:index, :create, :search_messages]

  def index
    @messages = Chat.connection.select_all("SELECT number, body, created_at, updated_at FROM messages")
    render json: @messages
  end

  def show
    render json: @message.as_json.except("id")
  end

  def create
    @message = @chat.messages.create(message_params.merge({number: @chat.next_message_number}))
    if @chat.save
      #@chat.update(messages_count: @chat.messages_count + 1, next_message_number: @chat.next_message_number + 1)
      render json: {msg: "Message created successfully", number: @message[:number]}, status: :ok
    else
      render json: {msg: @message.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update 
    if @message.update(message_params)
      render json: {msg: "Message updated successfully"}, status: :ok
    else
      render json: {msg: "Message update failed. Please double check the data provided"}, status: :unprocessable_entity
    end
  end

  def destroy 
    Message.destroy(@message.id)
    @chat.update(messages_count: @chat.messages_count - 1)
    render json: {msg: "Message destroyed successfully"}, status: :ok
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
        render json: {msg: "Message body must not be empty"}, status: :unprocessable_entity
      end
    end
end
