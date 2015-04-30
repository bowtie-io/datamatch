class MatchesController < ApplicationController
  responds_to :json

  def index
    @profiles = current_user_profile.match_profiles.page(params[:page])
    respond_with @profiles
  end

  def unnotified
    @profiles = current_user_profile.unnotified_match_profiles.page(params[:page])
    respond_with @profiles
  end

  def potential_match_profiles
    @profiles = current_user_profile.potential_matches_profiles.page(params[:page])
    respond_with @profiles
  end

  def create
    profile = Profile.find(params[:id])

    if current_user_profile.match(profile)
      render json: { status: 'ok' }
    else
      render json: { status: 'error', message: 'Unable to create match' }
    end
  end

  def confirm_notification
    render json: { status: 'error', message: 'TODO: Pending feature' }
  end
end
