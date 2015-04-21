class AddPlanToDetails < ActiveRecord::Migration
  def change
    add_column :details, :plan, :string
  end
end
