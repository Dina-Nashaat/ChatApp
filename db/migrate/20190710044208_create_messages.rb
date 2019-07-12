class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :number, null: false
      t.string :content
      t.references :chat, foreign_key: true, null: false
      t.references :application, foreign_key: true
      t.boolean :deleted, default: false

      t.timestamps
    end
    add_index :messages, [:application_id, :chat_id, :number], unique: true
  end
end
