class ChangeColumnTypeForDetailsInDetails < ActiveRecord::Migration
  def change
    change_column :details, :user_details, :text
  end
end
