class AddUserTagsToDetails < ActiveRecord::Migration
  def change
    add_column :details, :tags, :string
  end
end
