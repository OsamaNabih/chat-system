class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :application

  after_create :update_counts

  # This check is also enforced in the DB itself in case of two processes reading their respective inserts as unique at the same time
  # Commenting this out saves us an extra query to check if this [application_id, number] pair already exist
  #validates :number, uniqueness: { scope: :application_id, message: "Chat number must be unique per application"}

  # searchkick # [:messages]

  # def search_data
  #   {
  #     name: name,
  #     app_token: application.token,
  #     number: number,
  #     messages: messages
  #   }
  # end

  def update_counts
    application.update(chats_count: application.chats_count + 1, next_chat_number: application.next_chat_number + 1)
  end
end
