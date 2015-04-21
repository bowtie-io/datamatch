class ChangeColumnTypeForTagsInDetails < ActiveRecord::Migration
  def change
    change_column :details, :tags, :text
  end
end
