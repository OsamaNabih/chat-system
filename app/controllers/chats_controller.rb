class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, except: [:index, :create]
  before_action :block_blank_name, only: [:create, :update]

  def index 
    @chats = Chat.connection.select_all("SELECT number, name, messages_count, created_at, updated_at FROM chats")
    render json: @chats
  end

  def show
    render json: @chat.as_json(except: ["id", "next_message_number"])
  end

  def create
    #@chat = @app.chats.create(chat_params.merge({number: @app.next_chat_number}))
    #@chat = @app.chats.create(chat_params.merge({number: chat_number}))
    chat_number = self.get_chat_number
    chat = chat_params.merge({number: chat_number, application_id: @app.id})
    ChatCreationJob.perform_later chat
    render json: {msg: "Chat created successfully", number: chat_number}, status: :created
    #@chat = Chat.create(chat_params.merge({number: chat_number, application_id: @app.id}))
    # if @chat.save
    #   render json: {msg: "Chat created successfully", number: @chat[:number]}, status: :ok
    # else
    #   render json: {msg: @chat.errors.full_messages}, status: :unprocessable_entity
    # end
  end

  def update 
    if @chat.update(chat_params)
      render json: {msg: "Chat updated successfully"}, status: :ok
    else
      render json: {msg: "Chat update failed. Please double check the data provided"}, status: :unprocessable_entity
    end
  end

  def destroy 
    Chat.destroy(@chat.id)
    #Application.update(@app.id, {chats_count: @app.chats_count - 1})
    #@app.update(chats_count: @app.chats_count - 1)
    render json: {msg: "Chat destroyed successfully"}, status: :ok
  end

  private
    def chat_params
      params.require(:chat).permit(:name)
    end

    def block_blank_name
      if params[:name].to_s.strip.empty?
        render json: {msg: "Name must not be empty"}, status: :unprocessable_entity
      end
    end

    def get_chat_number
      redis_key = "app_#{params[:application_id]}_chat_number"
      redis_lock_key = redis_key + "lock"
      lock = $lock_manager.lock(redis_lock_key, 200)
      chat_number = $redis.get(redis_key)
      if chat_number.nil?
        chat_number = (@app.chats.maximum(:number) || 0) + 1
        $redis.set(redis_key, chat_number)
      end
      $redis.incr(redis_key)
      $lock_manager.unlock(lock)
      chat_number
    end
end
