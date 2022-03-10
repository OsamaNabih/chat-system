# class AppSoftDeleteJob < ApplicationJob
#   queue_as :default

#   def perform(app)
#     chats = app.chats
#     chats.update_all(deleted: true)
#     app_key = "app_#{app.token}"

#     chat_ids = chats.pluck("id")
#     messages = Message.where(chat_id: chat_ids)
#     messages.update_all(deleted: true)
    
#     app.update(deleted: true)
#   end
# end
