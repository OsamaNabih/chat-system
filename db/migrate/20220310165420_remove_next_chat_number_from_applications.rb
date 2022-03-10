class RemoveNextChatNumberFromApplications < ActiveRecord::Migration[5.2]
  def change
    remove_column :applications, :next_chat_number
  end
end
