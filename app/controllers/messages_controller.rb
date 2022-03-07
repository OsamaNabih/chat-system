class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, except: [:index, :create, :search]

  def index
    @messages = Chat.connection.select_all("SELECT number, body, created_at, updated_at FROM messages")
    render json: @messages
  end

  def show
    render json: @chat.as_json.except("id")
  end

  def create
    logger.info "---------------Chat: #{@chat}"
    @message = @chat.messages.create(message_params.merge({number: @chat.next_message_number}))
    if @chat.save
      @chat.update(messages_count: @chat.messages_count + 1, next_message_number: @chat.next_message_number + 1)
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
    @message.destroy
    @chat.update(messages_count: @chat.messages_count - 1)
    render json: {msg: "Message destroyed successfully"}, status: :ok
  end

  def search
    # If no search body, return all messages
    search_body = params[:body]
    if search_body.to_s.strip.empty?
      self.index
    end
    # Else search for partial match
    res = Message.search("bod")
    render json: res
    #Rails.logger.info(res)
    #render json: {msg: "We've arrived"}
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
