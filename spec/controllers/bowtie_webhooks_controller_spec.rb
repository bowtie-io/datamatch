require 'rails_helper'

describe BowtieWebhooksController do
  let(:secret_key)    { '_BOWTIE_PROJECT_SECRET_KEYXYZ' }
  let(:profile_data)  { { tags: %w(frontend backend full-stack), info: 'Hello world' } }
  let(:hook_data)     { { user_id: 123, data: profile_data}  }

  describe '#create' do
    before do
      expect(Rails.configuration).to receive(:bowtie_project_secret_key).and_return(secret_key)
    end

    it 'permits unknown event types' do
      hook_data[:event_type] = 'unknown.event'

      jwt = JWT.encode(hook_data, secret_key)
      post :create, jwt: jwt

      expect(response.status).to be(200)
    end

    it 'creates a user profile with `user.profile.updated` webhook' do
      hook_data[:event_type] = 'user.profile.tracked'

      jwt = JWT.encode(hook_data, secret_key)
      expect{ post :create, jwt: jwt }.to change{Profile.count}.by(1)
    end

    it 'updates a user profile with `user.profile.updated` webhook' do
      hook_data[:event_type] = 'user.profile.updated'
      profile = Profile.create(tag_name_array: %w(ruby))

      jwt = JWT.encode(hook_data, secret_key)
      post :create, jwt: jwt

      profile.reload
      expect(profile.tag_name_array).to eq(%w(ruby))
    end

    it 'denies access when given an invalid jwt' do
      jwt = JWT.encode(hook_data, '_INVALID_PROJECT_SECRET')
      post :create, jwt: jwt

      expect(response.status).to be(403)
    end
  end
end
