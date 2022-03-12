# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

env :PATH, ENV['PATH']
set :environment, ENV["RAILS_ENV"]
ENV.each_key do |key|
  env key.to_sym, ENV[key]
end

set :output, "./log/cron.log"

#job_type :rake,    "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"
#job_type :sidekiq, "cd :path && BUNDLE_PATH=/bundle /usr/local/bin/bundle exec sidekiq-client :task :output"

# These lines directly pushes a sidekiq job to the queue
# I opted to call a function in the model that then does the enqueueing in order to use Active Jobs in the same way all over our app
# job_type :sidekiq, "cd :path && :environment_variable=:environment bundle exec sidekiq-client :task :output"
# every 1.minute do
#   sidekiq "push UpdateChatsCountWorker"
#   command "echo 'hello' >> /home/osama/output.txt"
# end

every 30.minute do
  runner "Application.update_chats_count"
end

every 30.minute do
  runner "Chat.update_messages_count"
end

# Learn more: http://github.com/javan/whenever
