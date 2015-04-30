require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile){ Profile.create }
  let(:tag_names){ %w(frontend backend) }

  # Returns match records for completed matches to this profile
  describe '#matches' do
    it 'includes matches when main profile is on the left' do
      matched_profile = Profile.create
      match           = Match.create(left_profile: profile, right_profile: matched_profile)
      expect(profile.matches).to include(match)
    end

    it 'includes matches when main profile is on the right' do
      matched_profile = Profile.create
      match           = Match.create(left_profile: matched_profile, right_profile: profile)
      expect(profile.matches).to include(match)
    end

    it 'does not include an incomplete match' do
      match = Match.create(left_profile: profile, right_profile: nil)
      expect(profile.matches).to_not include(match)
    end
  end

  describe '#unnotified_matches' do
    it 'includes matches when main profile is on the left and has not been notified' do
      matched_profile = Profile.create
      match = Match.create(left_profile: profile, right_profile: matched_profile, left_profile_notified_at: nil)
      expect(profile.unnotified_matches).to include(match)
    end

    it 'includes matches when main profile is on the right and has not been notified' do
      matched_profile = Profile.create
      match = Match.create(left_profile: matched_profile, right_profile: profile, right_profile_notified_at: nil)
      expect(profile.unnotified_matches).to include(match)
    end

    it 'does not include matches when main profile is on the left and has already been notified' do
      matched_profile = Profile.create
      match = Match.create(left_profile: profile, right_profile: matched_profile, left_profile_notified_at: Time.now)
      expect(profile.unnotified_matches).to_not include(match)
    end

    it 'does not include matches when main profile is on the right and has already been notified' do
      matched_profile = Profile.create
      match = Match.create(left_profile: matched_profile, right_profile: profile, right_profile_notified_at: Time.now)
      expect(profile.unnotified_matches).to_not include(match)
    end

    it 'does not contain incomplete matches' do
      match = Match.create(left_profile: profile)
      expect(profile.unnotified_matches).to_not include(match)
    end
  end

  describe '#potential_match_profiles' do
    it 'includes only profiles within the same project'
    it 'includes only profiles more recent than the last match'
    it 'includes profiles that are not in the same category'
  end

  describe '#tag_name_array=' do
    it 'creates tag records for each tag name in an assigned array' do
      profile.tag_name_array = tag_names
      expect{ profile.save! }.to change{profile.tags.count}.by(tag_names.length)
    end

    it 'clears existing tag records for new tag array' do
      profile.tag_name_array = tag_names
      profile.save!

      expect{
        new_tags = %w(ruby python)
        profile.tag_name_array = new_tags
      }.to change{Tag.count}.by(0)
    end
  end

  describe '#tag_name_array' do
    before do
      tag_names.each do |tag_name|
        profile.tags << Tag.new(name: tag_name)
      end
    end

    it 'provides an array of tags from tag records' do
      expect(profile.tag_name_array).to eq(tag_names)
    end

    it 'provides the most recently assigned tag name array' do
      tag_name_array = %w(new tags)
      profile.tag_name_array = tag_name_array
      expect(profile.tag_name_array).to eq(tag_name_array)
    end
  end
end
