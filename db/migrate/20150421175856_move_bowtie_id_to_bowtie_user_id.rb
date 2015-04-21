class MoveBowtieIdToBowtieUserId < ActiveRecord::Migration
  def change
    rename_column :users, :bowtie_id, :bowtie_user_id
  end
end
