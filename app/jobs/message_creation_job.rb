class MessageCreationJob < ApplicationJob
  queue_as :default

  def perform(message)
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!MESSAGE CREATION JOB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Message.create(message)
  end
end
