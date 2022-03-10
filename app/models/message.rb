class Message < ApplicationRecord
  belongs_to :chat

  after_commit :update_cache
  after_destroy :clear_es_index

  validates :body, presence: true

  searchkick text_middle: [:body] #, callbacks: :async
  # Possible match options
  # text_start: [:body], text_middle: [:body], text_end: [:body], word_start: [:body], word_middle: [:body], word_end: [:body]

  @@redis_key_format = "app_%{app_token}_chat_%{chat_number}_msg_%{msg_number}"

  # Specify which fields Elasticsearch indexes
  def search_data
    {
      app_token: chat.application.token,
      chat_number: chat.number,
      body: body
    }
  end

  def self.redis_get(redis_key)
    msg_str = $redis.get(redis_key)
    msg = msg_str.nil? ? msg_str : Message.new.from_json(msg_str)
  end

  def redis_key_params
    { app_token: self.chat.application.token, chat_number: self.chat.number, msg_number: number }
  end

  def clear_es_index 
    Message.searchkick_index.remove(self)
  end
end
