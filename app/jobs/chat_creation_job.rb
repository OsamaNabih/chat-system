class ChatCreationJob < ApplicationJob
  queue_as :default

  def perform(chat)
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!WORKER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts chat.to_json
    Chat.create(chat)
    # Do something later
  end
end
