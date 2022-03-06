class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :number
      t.references :chat, null: false, foreign_key: true
      t.index [:number, :chat_id], unique: true

      t.timestamps
    end
  end
end
