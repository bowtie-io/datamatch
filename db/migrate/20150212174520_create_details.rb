class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details, id: false do |t|
      t.string  :sid,  :unique => true
      t.string  :project_sid
      t.string  :user_sid
      t.string  :user_details
      t.boolean :active

      t.timestamps null: false
    end
    add_index :details, :sid, unique: true
  end
end
