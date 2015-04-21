class CreateProjectUsersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :projects, :users do |t|
      t.string :project_id
      t.string :user_id
    end
  end
end
