class Application < ApplicationRecord
  has_many :chats, dependent: :delete_all
  #after_commit :update_cache
  #after_destroy :reset_cache

  has_secure_token

  after_commit :update_cache
  after_save :redis_set

  #scope :select_exclude_id, ->  { select( Application.attribute_names - ['id'] ) }

  # Class method so we can use it check the existence of an App in redis cache
  def self.redis_get(redis_key)
    app_str = $redis.get(redis_key)
    # if cache hasn't been set (value is nil) return nil, else parse it into an object
    app = app_str.nil? ? app_str : Application.new.from_json(app_str)
  end

  # Instance method to be called after saving or updating an app in the DB
  def redis_set
    puts "Caching app"
    redis_key = "app_#{token}"
    $redis.set(redis_key, self.to_json)
  end

  # def self.update_chats_count
  #   puts "Updating counts"
  #   apps = Application.all
  #   apps.each do |app|
  #     app.chats_count = app.chats.count
  #     app.save!
  #   end
  #   #self.chats_count = self.chats.count
  # end

  def self.update_chats_count
    UpdateChatsCountJob.perform_now
  end

  # Called after save, update, destroy to update our cache
  def update_cache
    self.redis_set
  end

  def cached?
    redis_key = "app_#{token}"
    !$redis.get(redis_key).nil?
  end

  
  def update_cache
    #if self.cached?
      #self.redis_set
    #end
    self.redis_set
  end

  ## Cache integrity functions for deletions

  # def reset_cache
  #   self.redis_clear
  # end

  # def redis_clear
  #   redis_key = "app_#{token}"
  #   $redis.del(redis_key)
  # end
end
