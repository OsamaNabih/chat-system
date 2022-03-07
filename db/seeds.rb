# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless Rails.env == "production"
  apps = []
  for idx in 1..3
    app = {name: "app#{idx}"}
    apps << app
  end

  # Bulk creation
  apps = Application.create(apps)
  
  chats = []
  apps.each do |app| 
    for idx in 1..3
      chat = app.chats.create(name: "app#{app.id}_chat#{idx}", number: idx)
      chats << chat
      app.update(chats_count: app.chats_count + 1, next_chat_number: app.next_chat_number + 1)
    end
  end

  chats.each do |chat|
    chat.messages.create(body: Faker::Lorem.sentence(word_count: 50, supplemental: false, random_words_to_add: 50), number: chat.next_message_number)
    chat.update(messages_count: chat.messages_count + 1, next_message_number: chat.next_message_number + 1)
  end
end