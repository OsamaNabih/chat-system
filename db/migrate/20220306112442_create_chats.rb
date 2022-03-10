class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number
      t.string :name
      t.integer :messages_count, default: 0
      t.integer :next_message_number, default: 1
      t.references :application, null: false, index: true
      t.index [:number, :application_id], unique: true

      t.timestamps
    end
    #add_foreign_key :chats, :applications, on_delete: :cascade
  end
end
