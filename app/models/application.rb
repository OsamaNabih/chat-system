class Application < ApplicationRecord
  has_many :chats, dependent: :delete_all

  has_secure_token

  @@redis_key_format = "app_%{app_token}"

  # Returns app if set in redis cache, else nil
  def self.redis_get(redis_key)
    app_str = $redis.get(redis_key)
    app = app_str.nil? ? app_str : Application.new.from_json(app_str)
  end

  def redis_key_params
    { app_token: token }
  end

  def self.update_chats_count
    UpdateChatsCountJob.perform_now
  end

end
