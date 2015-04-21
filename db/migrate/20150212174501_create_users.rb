class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.string  :sid,  :unique => true
      t.string  :bowtie_id
      t.string  :email
      t.string  :name
      t.boolean :active

      t.timestamps null: false
    end
    add_index :users, :sid, unique: true
  end
end
