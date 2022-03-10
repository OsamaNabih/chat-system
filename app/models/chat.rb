class Chat < ApplicationRecord
  has_many :messages, dependent: :delete_all
  belongs_to :application #, counter_cache: :chats_count

  #after_create :update_counts
  after_commit :update_cache

  validates :name, presence: true

  

  # This check is also enforced in the DB itself in case of two processes reading their respective inserts as unique at the same time
  # Commenting this out saves us an extra query to check if this [application_id, number] pair already exist
  #validates :number, uniqueness: { scope: :application_id, message: "Chat number must be unique per application"}

  
  # ElasticSearch in case we index the chats
  # searchkick # [:messages]

  # def search_data
  #   {
  #     name: name,
  #     app_token: application.token,
  #     number: number,
  #     messages: messages
  #   }
  # end

  def update_counts
    puts "Inside update counts"
    #CountRecalculationJob.perform_later self
    #application.update(chats_count: application.chats_count + 1, next_chat_number: application.next_chat_number + 1)
    #application.update(next_chat_number: application.next_chat_number + 1)
  end

  def self.update_messages_count
    UpdateMessagesCountJob.perform_now
  end

  def self.redis_get(redis_key)
    chat_str = $redis.get(redis_key)
    # if cache hasn't been set (value is nil) return nil, else parse it into an object
    chat = chat_str.nil? ? chat_str : Chat.new.from_json(chat_str)
  end

  def redis_set
    redis_key = "app_#{application.token}_chat_#{number}"
    $redis.set(redis_key, self.to_json)
  end

  def cached?
    redis_key = "app_#{application.token}_chat_#{number}"
    $redis.get(redis_key).nil?
  end

  
  def update_cache
    if self.cached?
      self.redis_set
    end
  end
end
