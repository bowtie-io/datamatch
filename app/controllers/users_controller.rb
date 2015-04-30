class UsersController < UserInterfaceController
  # potential matches
  def index
    @potential_matches = Profile.
      where(project_id: request.headers['X-Bowtie-Project']).                         # are part of the current project
      where('created_at > ?', current_user_profile.last_potential_match_created_at).  # are more recent than the last profile that we matched (so we don't need to check who we've already matched with)
      where('category != ?', current_user_profile.category).                          # are not the same category
      order('created_at asc').                                                        # order so our immediate next match is next in order over the last one
      page(params[:page])

    render json: @potential_matches
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
