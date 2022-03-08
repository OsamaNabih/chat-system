# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

#job_type :sidekiq, "cd :path && BUNDLE_PATH=/bundle /usr/local/bin/bundle exec sidekiq-client :task :output"
env :PATH, ENV['PATH']

set :output, "~/chat-system-api/log/cron.log"

# every 1.minute do
#   #sidekiq "push GenerateExportsWorker"
#   runner "Application.update_chats_count"
# end

# every 1.minute do
#   runner "Application.update_chats_count"
#   command "echo 'App runner' >> /home/osama/output.txt"
# end

# every 1.minute do
#   rake 'apps:update_chats_count'
#   command "echo 'ran rake'"
# end

# every 1.minute do
#   runner "UpdateChatsCountWorker.perform_async"
#   command "echo 'runner' >> /home/osama/output.txt"
# end

# every 1.minute do
#   command "echo 'test'"
#   command "echo 'hello' >> /home/osama/output.txt"
# end
#job_type :rake,    "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"
#job_type :sidekiq, "cd :path && BUNDLE_PATH=/bundle /usr/local/bin/bundle exec sidekiq-client :task :output"

# job_type :sidekiq, "cd :path && :environment_variable=:environment bundle exec sidekiq-client :task :output"

# every 1.minute do
#   sidekiq "push UpdateChatsCountWorker"
#   command "echo 'hello' >> /home/osama/output.txt"
# end

every 1.minute do
  runner "Application.update_chats_count"
end

every 1.minute do
  runner "Chat.update_messages_count"
end

# Learn more: http://github.com/javan/whenever
