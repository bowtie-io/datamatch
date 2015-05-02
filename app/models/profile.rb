class Profile < ActiveRecord::Base
  has_many   :tags, dependent: :destroy

  after_save :update_tags
  after_destroy :remove_matches

  def match_with(profile)
    # Check to see if the profile we're matching with already tried to match with us
    match = Match.find_by(left_profile_id: profile.id)

    if match
      match.update_attributes!(right_profile: self, right_profile_matched_at: Time.now)
    else
      match = Match.create(left_profile: self, left_profile_matched_at: Time.now)
    end

    update_attributes!(last_potential_match_created_at: profile.created_at)

    match.valid?
  end

  def match_profiles
    left_matches  = Match.select('left_profile_id as profile_id').
      where('right_profile_id = ? and left_profile_id is not null', id)

    right_matches = Match.select('right_profile_id as profile_id').
      where('left_profile_id = ? and right_profile_id is not null', id)

    Profile.where('id in (?) or id in (?)', left_matches, right_matches)
  end

  def unnotified_match_profiles
    left_matches  = Match.select('left_profile_id as profile_id').
      where('right_profile_id = ? and left_profile_id is not null', id).
      where('right_profile_notified_at is null')

    right_matches = Match.select('right_profile_id as profile_id').
      where('left_profile_id = ? and right_profile_id is not null', id).
      where('left_profile_notified_at is null')

    Profile.where('id in (?) or id in (?)', left_matches, right_matches)
  end

  def potential_match_profiles
    # are part of the current project
    profiles = Profile.where(bowtie_project_id: bowtie_project_id)

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

  def obfuscate
    if email
      @obfuscated ||= (self.email = '...@' + email.split('@').last)
    else
      "...@..."
    end
  end

  def as_json(*args)
    {
      id: id,
      info: info,
      tags: tag_name_array,
      name: name,
      email: email
    }
  end

  private
  def remove_matches
    Match.where("left_profile_id = :id or right_profile_id = :id", id: id).destroy_all
  end

  def update_tags
    self.tags = tag_name_array.collect { |tag_name| Tag.new(name: tag_name) }
  end
end
