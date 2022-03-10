class AddDeletedColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :deleted, :boolean, default: :false
    add_column :chats, :deleted, :boolean, default: :false
    add_column :messages, :deleted, :boolean, default: :false
  end
end
