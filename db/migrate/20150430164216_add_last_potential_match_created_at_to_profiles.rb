class AddLastPotentialMatchCreatedAtToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :last_potential_match_created_at, :datetime
  end
end
