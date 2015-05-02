class MatchesController < ApplicationController
  def confirmed
    render json: { status: 'ok' }.merge(paginate_collection(@profiles))
    @profiles = current_user_profile.match_profiles.page(params[:page])
  end

  def unnotified
    @profiles = current_user_profile.unnotified_match_profiles.page(params[:page])
    render json: { status: 'ok' }.merge(paginate_collection(@profiles))
  end

  def potential
    render json: { status: 'ok' }.merge(paginate_collection(@profiles))
    @profiles = current_user_profile.potential_match_profiles.page(1).per(5)
  end

  def pass
    profile = Profile.find(params[:matched_profile_id])
    current_user_profile.update_attributes!(last_potential_match_created_at: profile.created_at)
    render json: { status: 'ok' }
  end

  def accept
    profile = Profile.find(params[:matched_profile_id])

    if current_user_profile.match_with(profile)
      render json: { status: 'ok' }
    else
      render json: { status: 'error', detail: 'profile-match-error' }
    end
  end

  def confirm_notification
    # TODO better left_profile / right_profile organization would simplify this

    sql_params = {
      matched_profile_id: params[:matched_profile_id],
      current_user_profile_id: current_user_profile.id
    }

    Match.where('(left_profile_id = :current_user_profile_id and
                  right_profile_id = :matched_profile_id)', sql_params).
      update_all(['left_profile_notified_at = ?', Time.now])

    Match.where('(right_profile_id = :current_user_profile_id and
                  left_profile_id = :matched_profile_id)', sql_params).
      update_all(['right_profile_notified_at = ?', Time.now])

    render json: { status: 'ok' }
  end

  private
  def paginate_collection(collection)
    { data:     collection,
      has_more: !collection.last_page?,
      page:     (params[:page] || 1) }
  end
end
