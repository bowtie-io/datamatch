class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token # OUCH

  before_action :verify_bowtie_user
  before_action :verify_profile_exists

  private
  def current_bowtie_user_id
    request.headers['HTTP_X_BOWTIE_USER_ID']
  end

  def current_bowtie_user_plan
    request.headers['HTTP_X_BOWTIE_USER_PLAN']
  end

  def current_user_profile
    Profile.find_by bowtie_user_id: current_bowtie_user_id
  end

  def verify_profile_exists
    unless current_user_profile
      render json: { status: 'error', detail: 'profile-required' } and return false
    end
  end

  def verify_bowtie_user
    unless current_bowtie_user_id
      render json: { status: 'error', detail: 'session-required' } and return false
    end
  end
end
