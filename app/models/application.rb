class Application < ApplicationRecord
  has_many :chats, dependent: :delete_all
  after_commit :update_cache

  has_secure_token

  #scope :select_exclude_id, ->  { select( Application.attribute_names - ['id'] ) }

  # Class method so we can use it check the existence of an App in redis cache
  def self.redis_get(redis_key)
    app_str = $redis.get(redis_key)
    # if cache hasn't been set (value is nil) return nil, else parse it into an object
    app = app_str.nil? ? app_str : Application.new.from_json(app_str)
  end

  # Instance method to be called after saving or updating an app in the DB
  def redis_set
    redis_key = "app_#{token}"
    $redis.set(redis_key, self.to_json)
  end

  # Called after save, update, destroy to update our cache
  def update_cache
    self.redis_set
  end
end
