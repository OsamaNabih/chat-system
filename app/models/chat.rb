class Chat < ApplicationRecord
  has_many :messages
  belongs_to :application

  after_commit :update_cache

  @@redis_key_format = "app_%{app_token}_chat_%{chat_number}"

  def self.update_messages_count
    UpdateMessagesCountJob.perform_now
  end

  def self.redis_get(redis_key)
    chat_str = $redis.get(redis_key)
    chat = chat_str.nil? ? chat_str : Chat.new.from_json(chat_str)
  end

  def redis_key_params
    { app_token: self.application.token, chat_number: number }
  end

  # This check is also enforced in the DB itself in case of two processes reading their respective inserts as unique at the same time
  # Commenting this out saves us an extra query to check if this [application_id, number] pair already exist
  #validates :number, uniqueness: { scope: :application_id, message: "Chat number must be unique per application"}

  
  # ElasticSearch in case we index the chats
  # searchkick

  # def search_data
  #   {
  #     name: name,
  #     app_token: application.token,
  #     number: number,
  #     messages: messages
  #   }
  # end



end
