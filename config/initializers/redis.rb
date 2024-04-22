host = ENV['REDIS_HOST'] || "redis"
port = ENV['REDIS_PORT'] || 6379
db = ENV['REDIS_DB'] || 0
url = "redis://" + host + ":" + port.to_s

$redis = Redis.new(url: url)
$lock_manager = Redlock::Client.new([ url ])