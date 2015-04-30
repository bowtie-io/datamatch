class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :left_profile_id
      t.integer :right_profile_id
      t.datetime :left_profile_matched_at
      t.datetime :right_profile_matched_at
      t.datetime :left_profile_notified_at
      t.datetime :right_profile_notified_at

      t.timestamps null: false
    end
    add_index :matches, :left_profile_id
    add_index :matches, :right_profile_id
  end
end
