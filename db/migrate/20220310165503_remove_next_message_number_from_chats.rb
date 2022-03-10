class RemoveNextMessageNumberFromChats < ActiveRecord::Migration[5.2]
  def change
    remove_column :chats, :next_message_number
  end
end
