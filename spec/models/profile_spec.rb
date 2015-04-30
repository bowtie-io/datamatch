require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile){ Profile.create }
  let(:tag_names){ %w(frontend backend) }


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
