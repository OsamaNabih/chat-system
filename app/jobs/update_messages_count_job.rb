class UpdateMessagesCountJob < ApplicationJob
  queue_as :default

  # 1 query to fetch chats, Need only 1 query to get the messages count for each chat
  # 1 query per saved chat ONLY if its messages_count changes
  # Avoid locking the table repeatedly when doing N+1 COUNT(*) query for each chat
  def perform
    puts "------------------------UpdateMessagesCountJob Job start------------------------"
    puts "#{Time.new.inspect}"

    chats = Chat.all
    chats_hash = chats.index_by(&:id)

    messages_counts = Message.group(:chat_id).count
    messages_counts.each do |chat_id, count|
      chat = chats_hash[chat_id]

      # Here we choose update_column instead of save as this avoids a fetch query to get the parent application
      # However update_column ALWAYS issues an update query so we need to check if the count has changed manually
      unless chat.messages_count == count
        chat.update_column(:messages_count, count)
        # Need to explicitly call this as update_column won't call after_commit
        chat.update_cache
      end
    end
    print "------------------------Job end------------------------\n\n"
  end
end
