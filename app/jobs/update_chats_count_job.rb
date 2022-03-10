class UpdateChatsCountJob < ApplicationJob
  queue_as :default

  # 1 query to fetch apps, Need only 1 query to get the chats count for each app
  # 1 query per saved app ONLY if its chats_count changes
  # Avoid locking the table repeatedly when doing N+1 COUNT(*) query for each app
  def perform
    puts "Updating apps chats_count job"
    apps = Application.all
    apps_hash = apps.index_by(&:id)

    
    #start = 1
    #finish = 3
    
    #chats_counts = Application.connection.select_all('SELECT c.application_id, Count(*) as count_all FROM `chat-system-api_development`.chats as c GROUP BY c.application_id;')
    #chats_counts = Chat.where("application_id >= #{start} and application_id <= #{finish}").group(:application_id).count
    chats_counts = Chat.group(:application_id).count
    puts chats_counts
    chats_counts.each do |application_id, count|
      app = apps_hash[application_id]
      # Here we don't have to worry about fetching a parent, and we do need to set the updated_at field
      # So we opt for saving the record instead of update_column
      # An update query will only be issued if the count_all has changed
      app.chats_count = count
      app.save!
      app.update_cache
    end
  end
end

