class ChatCreationJob < ApplicationJob
  queue_as :default

  def perform(chat)
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CHAT CREATION JOB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Chat.create(chat)
  end
end
