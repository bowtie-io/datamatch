class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects, id: false do |t|
      t.string :sid,  :unique => true
      t.string :name
      t.string :auth_domain
      t.text   :user_details
      t.string :name
      t.string :match_types
      t.string :global_match
      t.boolean :active

      t.timestamps null: false
    end
    add_index :projects, :sid, unique: true
  end
end
