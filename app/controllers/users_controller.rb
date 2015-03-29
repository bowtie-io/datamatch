class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # potential matches
  def index
    all_users = current_project.users
    current_matches = current_user.matches

    match_objects = []
    current_matches.each do |match|
      match_objects << User.find(match.matched_id)
    end


    potentials = []
    all_users.each do |user|
        unless match_objects.include? user
        potentials << user
      end
    end


    render :json => {potential_matches: potentials.map(&:id)}
  end

  # user details
  def show
    user = User.find(params[:id])
    details = Detail.where(["project_sid = :u && user_sid = :t", { u: current_project.id, t: user.id }])
    render :json => {user: user, details: details.first.user_details}
  end

end
