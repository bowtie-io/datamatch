require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile){ Profile.create }
  let(:tag_names){ %w(frontend backend) }

  # Returns match records for completed matches to this profile
  describe '#match_profiles' do
    it 'includes matches when main profile is on the left' do
      matched_profile = Profile.create
      Match.create(left_profile: profile, right_profile: matched_profile)
      expect(profile.match_profiles).to include(matched_profile)
    end

    it 'includes matches when main profile is on the right' do
      matched_profile = Profile.create
      Match.create(left_profile: matched_profile, right_profile: profile)
      expect(profile.match_profiles).to include(matched_profile)
    end

    it 'does not include an incomplete match' do
      Match.create(left_profile: profile, right_profile: nil)
      expect(profile.match_profiles).to be_empty
    end
  end

  describe '#unnotified_match_profiles' do
    it 'includes matches when main profile is on the left and has not been notified' do
      matched_profile = Profile.create
      Match.create(left_profile: profile, right_profile: matched_profile, left_profile_notified_at: nil)
      expect(profile.unnotified_match_profiles).to include(matched_profile)
    end

    it 'includes matches when main profile is on the right and has not been notified' do
      matched_profile = Profile.create
      Match.create(left_profile: matched_profile, right_profile: profile, right_profile_notified_at: nil)
      expect(profile.unnotified_match_profiles).to include(matched_profile)
    end

    it 'does not include matches when main profile is on the left and has already been notified' do
      matched_profile = Profile.create
      Match.create(left_profile: profile, right_profile: matched_profile, left_profile_notified_at: Time.now)
      expect(profile.unnotified_match_profiles).to_not include(matched_profile)
    end

    it 'does not include matches when main profile is on the right and has already been notified' do
      matched_profile = Profile.create
      Match.create(left_profile: matched_profile, right_profile: profile, right_profile_notified_at: Time.now)
      expect(profile.unnotified_match_profiles).to_not include(matched_profile)
    end

    it 'does not contain incomplete matches' do
      Match.create(left_profile: profile)
      expect(profile.unnotified_match_profiles).to be_empty
    end
  end

  describe '#potential_match_profiles' do
    it 'includes only profiles within the same project'
    it 'includes only profiles more recent than the last match'
    it 'includes profiles that are not in the same category'
  end

  describe '#match' do
    it 'creates a new match record when no match initiated by another profile'
    it 'updates an existing match record when match already initiated by another profile'
  end

  describe '#obfuscate' do
    it 'obfuscates the username portion of the email address' do
      profile.email = 'james@example.com'
      profile.obfuscate

      expect(profile.email).to eq('...@example.com')
    end
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
