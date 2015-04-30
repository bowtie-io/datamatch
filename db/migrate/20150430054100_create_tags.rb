class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :profile_id
      t.string :name

      t.timestamps null: false
    end
    add_index :tags, :profile_id
    add_index :tags, :name
  end
end
