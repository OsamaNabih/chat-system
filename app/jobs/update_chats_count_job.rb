class UpdateChatsCountJob < ApplicationJob
  queue_as :default

  # 1 query to fetch apps, Need only 1 query to get the chats count for each app
  # 1 query per saved app ONLY if its chats_count changes
  # Avoid locking the table repeatedly when doing N+1 COUNT(*) query for each app
  def perform
    puts "Updating apps chats_count job"
    apps = Application.all
    chats_counts = Application.connection.select_all('SELECT c.application_id, Count(*) as count FROM `chat-system-api_development`.chats as c GROUP BY c.application_id ORDER BY c.application_id;')
    apps.each_with_index do |app, idx|
      app.chats_count = chats_counts[idx]["count"]
      app.save!
    end
  end
end
