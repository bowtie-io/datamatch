class ReorderColumnsInDetails < ActiveRecord::Migration
  def change
    change_column :details, :tags, :string, after: :user_details
  end
end
