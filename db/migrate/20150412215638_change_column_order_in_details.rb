class ChangeColumnOrderInDetails < ActiveRecord::Migration
  def change
    change_column :details, :plan, :string, after: :user_sid
  end
end
