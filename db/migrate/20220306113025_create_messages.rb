class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :number
      t.references :chat, null: false, index: true
      t.index [:number, :chat_id], unique: true

      t.timestamps
    end
    #add_foreign_key :messages, :chats, on_delete: :cascade
  end
end
