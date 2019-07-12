class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :access_token, null: false
      t.string :name, null: false
      t.integer :chats_count,  default: 0
      t.boolean :deleted, default: false

      t.timestamps
    end
    add_index :applications, :access_token, unique: true
  end
end
