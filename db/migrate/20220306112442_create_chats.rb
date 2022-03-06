class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number
      t.string :name
      t.integer :messages_count, default: 0
      t.references :application, null: false, foreign_key: true
      t.index [:number, :application_id], unique: true

      t.timestamps
    end
    #add_index :people, [:firstname, :lastname, :dob], unique: true
  end
end
