require 'rails_helper'

describe MatchesController do
  let(:current_user_profile) { Profile.create(bowtie_user_id: 'ABC') }
  let(:matched_user_profile) { Profile.create(bowtie_user_id: 'XYZ') }

  before do
    allow(controller).to receive(:current_user_profile).and_return(current_user_profile)
    allow(controller).to receive(:current_bowtie_user_id).and_return(current_user_profile.bowtie_user_id)
  end

  describe '#confirmed' do
    it 'responds successfully with data' do
      get :confirmed
      expect(response.body).to have_paginated_data_keys
    end
  end


  describe '#unnotified' do
    it 'responds successfully with data' do
      get :unnotified
      expect(response.body).to have_paginated_data_keys
    end
  end

  describe '#potential_match_profiles' do
    it 'responds successfully with data' do
      get :potential
      expect(response.body).to have_paginated_data_keys
    end
  end

  describe '#create' do
    it 'creates a new match record' do

    end
  end

  describe '#confirm_notification' do
    it 'sets notification time when current profile is left_profile' do
      Match.create(left_profile: current_user_profile, right_profile: matched_user_profile)
      post :confirm_notification, matched_profile_id: matched_user_profile.id
      expect(response.body).to have_ok_status
    end

    it 'sets notification time when current profile is right_profile' do
      post :confirm_notification, matched_profile_id: matched_user_profile.id
      expect(response.body).to have_ok_status
    end
  end
end
