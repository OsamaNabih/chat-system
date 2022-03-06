class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :token, limit: 24 # default length for has_secure_token
      t.string :name
      t.integer :chats_count, default: 0
      t.integer :next_chat_number, default: 1
      t.index :token, unique: true

      t.timestamps
    end
  end
end
