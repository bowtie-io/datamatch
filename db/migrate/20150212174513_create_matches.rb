class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches, id: false do |t|
      t.string :sid,  :unique => true
      t.string :user_id
      t.string :matched_id
      t.string :project_id
      t.boolean :decision

      t.timestamps null: false
    end
    add_index :matches, :sid, unique: true
  end
end
