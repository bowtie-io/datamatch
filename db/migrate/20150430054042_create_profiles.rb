class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :bowtie_user_id
      t.string :bowtie_project_id

      t.text :info

      t.timestamps null: false
    end
  end
end
