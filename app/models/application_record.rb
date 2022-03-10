class ApplicationRecord < ActiveRecord::Base
  after_commit :update_cache

  self.abstract_class = true

  # Sets the current object in redis cache
  def redis_set
    puts "Caching #{self.class}"
    redis_key = self.class.get_redis_key(self.redis_key_params)
    $redis.set(redis_key, self.to_json, {ex: 3600})
  end

  def self.redis_clear(key)
    $redis.del(key)
  end

  def self.get_redis_key(params)
    self.class_variable_get(:@@redis_key_format) % params
  end

  def self.new_obj(obj_class)
    puts obj_class.class
    case obj_class
      when Application
        obj = Application.new
      when Chat
        obj = Chat.new
      when Message
        obj = Message.new
    end
    obj
  end

  # Is called after each commit to update our cache
  def update_cache
    self.redis_set
  end

  def reset_cache
    puts "Deleting #{self.class} from cache"
    redis_key = self.class.get_redis_key(self.redis_key_params)
    $redis.del(redis_key)
  end
    
  def cached?
    redis_key = self.get_redis_key(token)
    !$redis.get(redis_key).nil?
  end
end
