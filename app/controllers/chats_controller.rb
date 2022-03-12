class ChatsController < ApplicationController
  before_action :set_application, except: :create
  before_action :set_chat, except: [:index, :create]
  before_action :block_blank_name, only: [:create, :update]

  def index 
    chats = Chat.where(application_id: @app.id).limit(@per_page).offset(@page*@per_page)
    render json: format_response(chats)
  end

  def show
    render json: format_response(@chat)
  end

  def create
    chat_number = get_chat_number
    chat = chat_params.merge({number: chat_number, application_id: @app.id})
    ChatCreationJob.perform_later chat
    render json: {msg: "Chat creation scheduled successfully", number: chat_number}, status: :created
  end

  def update 
    if Chat.update(@chat.id, chat_params)
      render json: {msg: "Chat updated successfully"}, status: :ok
    else
      render json: {msg: "Chat update failed. Please double check the data provided"}, status: :unprocessable_entity
    end
  end

  def destroy 
    Chat.destroy(@chat.id)
    Chat.redis_clear(@chat_redis_key)
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
      redis_lock_key = @chat_redis_key.to_s + "_lock"
      lock = $lock_manager.lock(redis_lock_key, 200)
      chat_number = $redis.get(@chat_redis_key)
      if chat_number.nil?
        chat_number = (@app.chats.maximum(:number) || 0) + 1
        $redis.set(@chat_redis_key, chat_number + 1)
      end
      $lock_manager.unlock(lock)
      chat_number.to_i
    end

    def format_response(response)
      super(response, [:id, :application_id])
    end

end
