class UpdateChatsCountJob < ApplicationJob
  queue_as :default

  # 1 query to fetch apps, Need only 1 query to get the chats count for each app
  # 1 query per saved app ONLY if its chats_count changes
  # Avoid locking the table repeatedly when doing N+1 COUNT(*) query for each app
  # If this proves too costly we could partition the workd load by specifying a
  # start and finish application_id parameters to each worker
  def perform
    puts "------------------------UpdateChatsCountJob Job start------------------------"
    puts "#{Time.new.inspect}"
    apps = Application.all
    apps_hash = apps.index_by(&:id)

    #start = 1
    #finish = 3
    #chats_counts = Chat.where("application_id >= #{start} and application_id <= #{finish}").group(:application_id).count
    
    chats_counts = Chat.group(:application_id).count

    chats_counts.each do |application_id, count|
      app = apps_hash[application_id]
      if app.nil?
        next
      end
      # Here we don't have to worry about fetching a parent, and we do need to set the updated_at field
      # So we opt for saving the record instead of update_column
      # An update query will only be issued if the count has changed
      app.chats_count = count
      if app.changed?
        app.save!
        app.update_cache
      end
    end
    print "------------------------Job end------------------------\n\n"
  end
end

