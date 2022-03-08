class UpdateMessagesCountJob < ApplicationJob
  queue_as :default

  # 1 query to fetch chats, Need only 1 query to get the messages count for each chat
  # 1 query per saved chat ONLY if its messages_count changes
  # Avoid locking the table repeatedly when doing N+1 COUNT(*) query for each chat
  def perform
    puts "Updating chats messages_count job"
    chats = Chat.all
    chats_hash = chats.index_by(&:id)
    messages_counts = Chat.connection.select_all('SELECT m.chat_id, Count(*) as count FROM `chat-system-api_development`.messages as m GROUP BY m.chat_id ORDER BY m.chat_id;')
    messages_counts.each do |res|
      chat = chats_hash[res["chat_id"]]
      # Here we choose update_column instead of save as this avoids a fetch query to get the parent application to update its "updated_at" field
      # However update_column ALWAYS issues an update query so we need to check if the count has changed manually
      unless chat.messages_count == res["count"]
        chat.update_column(:messages_count, res["count"])
        chat.update_cache
      end
    end
  end
end
