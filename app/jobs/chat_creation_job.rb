class ChatCreationJob < ApplicationJob
  queue_as :default

  def perform(chat)
    Rails.logger.info "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CHAT CREATION JOB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Chat.create(chat)
  end
end
