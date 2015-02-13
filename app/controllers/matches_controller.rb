class MatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    matches = current_user.matches.where(:decision => true)
    render json: {matches: matches.map(&:matched_id)}
  end

  def create
    match = Match.new match_params
    match.user = current_user
    match.project = current_project
    match.save!
    render json: {status: "ok"}
  end

  private
  def match_params
    params.require(:match).permit(:decision, :matched_id)
  end

end
