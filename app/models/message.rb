class Message < ApplicationRecord
  belongs_to :chat

  searchkick

  def search_data
    {
      app_token: chat.application.token,
      chat_number: chat.number,
      body: body
    }
  end
end
