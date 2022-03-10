# class UpdateChatsCountWorker
#   include Sidekiq::Worker

#   def perform
#     puts "##########################Inside the worker######################"
#     Application.update_chats_count
#   end
# end