class UpdateMessagesCountJob < ApplicationJob
  queue_as :default

  # 1 query to fetch chats, Need only 1 query to get the messages count for each chat
  # 1 query per saved chat ONLY if its messages_count changes
  # Avoid locking the table repeatedly when doing N+1 COUNT(*) query for each chat
  def perform
    puts "Updating chats messages_count job"
    chats = Chat.all
    messages_counts = chat.connection.select_all('SELECT m.chat_id, Count(*) as count FROM `chat-system-api_development`.messages as m GROUP BY m.chat_id ORDER BY m.chat_id;')
    chats.each_with_index do |chat, idx|
      chat.messages_count = messages_counts[idx]["count"]
      chat.save!
    end
  end
end
