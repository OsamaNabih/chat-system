Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://172.20.128.3:6379/0') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://172.20.128.3:6379/0') }
end
