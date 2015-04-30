require 'rails_helper'

RSpec.describe Match, type: :model do
  it 'forces the left profile to be set before the right profile' do
    profile = Profile.create
    match   = Match.new(right_profile: profile)

    expect(match).to_not be_valid
  end
end
