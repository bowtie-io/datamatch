class Profile < ActiveRecord::Base
  has_many   :tags
  after_save :update_tags

  def matches
    Match.where('
      (right_profile_id = :id and left_profile_id is not null) or
      (left_profile_id = :id and right_profile_id is not null)
    ', id: id)
  end

  def unnotified_matches
    Match.where('
      (right_profile_id = :id and left_profile_id is not null and right_profile_notified_at is null) or
      (left_profile_id = :id and right_profile_id is not null and left_profile_notified_at is null)
    ', id: id)
  end

  def potential_match_profiles
    # are part of the current project
    profiles = Profile.where(project_id: project_id)

     # are more recent than the last match unless we haven't had one (so we don't need to check who we've already matched with)
    profiles = profiles.where('created_at > ?', last_potential_match_created_at) unless last_potential_match_created_at.nil?

    # are not the same category
    profiles = profiles.where('category != ?', category)

    # should be ordered so we don't have to check who we've already matched with
    profiles = profiles.order('created_at asc')
  end

  def tag_name_array=(tag_name_array)
    @tag_name_array = tag_name_array
  end

  def tag_name_array
    @tag_name_array || tags.collect(&:name)
  end

  private
  def update_tags
    self.tags = tag_name_array.collect { |tag_name| Tag.new(name: tag_name) }
  end
end
