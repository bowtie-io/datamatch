class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :verify_bowtie_user
  before_action :verify_project

  def current_user_id
    request.headers['HTTP_X_BOWTIE_USER_ID']
  end

  def current_user
    User.find_by bowtie_id: current_user_id
  end

  def current_project_sid
   params[:project_sid]
  end

  def current_project
    Project.find current_project_sid
  end


  private
  def verify_bowtie_user
    if current_user_id.nil?
      respond_to do |format|
        format.json { render json: { status: :error, message: "Not Authorized" }, status: 403 }
      end
      return false
    end
    create_user
  end

  def verify_project
    if current_project_sid.nil?
      respond_to do |format|
        format.json { render json: { status: :error, message: "No Project Set"}, status: 403 }
      end
      return false
    end
  end

  def create_user
    unless User.exists?(:bowtie_id => current_user_id)
      User.create(
        :bowtie_id => current_user_id,
        :name => request.headers['HTTP_X_BOWTIE_USER_NAME'],
        :email => request.headers['HTTP_X_BOWTIE_USER_EMAIL'],
        :active => true
        )
    end
  end

  def assign_user
    current_project.users << current_user unless  current_project.users.exists?(current_user)
  end

end
