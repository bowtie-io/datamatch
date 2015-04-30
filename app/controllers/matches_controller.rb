class MatchesController < UserInterfaceController
  responds_to :json

  def index
    @profiles = current_user_profile.matches.page(params[:page])
    respond_with @profiles
  end

  def unnotified
    @profiles = current_user_profile.unnotified_matches.page(params[:page])
    respond_with @profiles
  end

  def potential_match_profiles
    @profiles = current_user_profile.potential_matches_profiles.page(params[:page])
    render json: @profiles
  end

  def index
    matches = current_user.matches.where(:decision => true)

    matched_users = []

    matches.each do |match|
      if Match.exists?(matched_id: current_user.id, user_id: match.matched_id)
        matched_users << User.find(match.matched_id)
      end
    end

    render json: {matches: matched_users.map(&:id)}
  end

  def create
    match = Match.new params.permit(:decision, :matched_id)
    match.user = current_user
    match.project = current_project
    match.save!
    render json: {status: "ok"}
  end

end
