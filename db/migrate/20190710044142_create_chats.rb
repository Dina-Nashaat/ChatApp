class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number, null: false
      t.references :application, foreign_key: true
      t.integer :messages_count,  default: 0
      t.boolean :deleted, default: false

      t.timestamps
    end
    add_index :chats, [:application_id, :number], unique: true
  end
end
