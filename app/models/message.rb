class Message < ApplicationRecord
  belongs_to :chat, counter_cache: :messages_count

  after_create :update_counts
  #after_commit :searchkick_indexing

  validates :body, presence: true

  searchkick text_middle: [:body]
  
  # Possible match options
  # text_start: [:body], text_middle: [:body], text_end: [:body], word_start: [:body], word_middle: [:body], word_end: [:body]

  def search_data
    {
      app_token: chat.application.token,
      chat_number: chat.number,
      body: body
    }
  end

  def update_counts
    #chat.update(messages_count: chat.messages_count + 1, next_message_number: chat.next_message_number + 1)
    #chat.update(next_message_number: chat.next_message_number + 1)
  end

  # def searchkick_indexing
  #   Message.reindex
  # end
end
