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
        unless match_objects.include? user or user.id == current_user.id
        potentials << user
      end
    end

    render :json => {potential_matches: potentials.map(&:id)}
  end


  def update
    detail = Detail.where(["project_sid = :u && user_sid = :t", { u: current_project.id, t: current_user.id }]).first
    detail.tags = params[:tags]
    detail.user_details = params[:details]
    detail.save!

    render :json => {status: "user updated"}
  end



  # user details
  def show
    if params[:id] == "self"
      user = current_user
    else
      user = User.find(params[:id])
    end

    _detail = Detail.where(["project_sid = :u && user_sid = :t", { u: current_project.id, t: user.id }])
    details = _detail.first.user_details rescue nil
    tags = _detail.first.tags rescue nil

    if current_user_plan == "Startup"
      user.email = user.email.gsub(/.{0,4}@/, '****@')
    end

    render :json => {user: user, details: details, tags: tags, plan: details.plan}

  end

end
