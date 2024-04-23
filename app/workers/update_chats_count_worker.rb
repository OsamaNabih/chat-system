# class UpdateChatsCountWorker
#   include Sidekiq::Worker

#   def perform
#     Rails.logger.info "##########################Inside the worker######################"
#     Application.update_chats_count
#   end
# end