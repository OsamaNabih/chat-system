class Message < ApplicationRecord
  belongs_to :chat

  #after_create :update_counts
  #after_commit :searchkick_indexing
  after_commit :update_cache

  validates :body, presence: true

  searchkick text_middle: [:body]
  
  # Possible match options
  # text_start: [:body], text_middle: [:body], text_end: [:body], word_start: [:body], word_middle: [:body], word_end: [:body]

  def search_data
    {
      app_token: chat.application.token,
      chat_number: chat.number,
      body: body
    }
  end

  def self.redis_get(redis_key)
    msg_str = $redis.get(redis_key)
    # if cache hasn't been set (value is nil) return nil, else parse it into an object
    msg = msg_str.nil? ? msg_str : Message.new.from_json(msg_str)
  end

  def redis_set
    puts "Caching message"
    redis_key = "app_#{chat.application.token}_chat_#{chat.number}_msg_#{number}"
    $redis.set(redis_key, self.to_json)
  end

  def cached?
    redis_key = "app_#{chat.application.token}_chat_#{chat.number}_msg_#{number}"
    !$redis.get(redis_key).nil?
  end

  def update_cache
    #if self.cached?
      #self.redis_set
    #end
    self.redis_set
  end

  # def searchkick_indexing
  #   Message.reindex
  # end
end
