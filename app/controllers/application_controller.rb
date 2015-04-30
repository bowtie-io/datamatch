class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token # OUCH

  def current_bowtie_user_id
    request.headers['HTTP_X_BOWTIE_USER_ID']
  end

  def current_user_plan
    request.headers['HTTP_X_BOWTIE_USER_PLAN']
  end

  def current_user
    User.find_by bowtie_user_id: current_bowtie_user_id
  end

  def current_project_sid
    params[:project_sid]
  end

  def current_project
    Project.find current_project_sid
  end
end
