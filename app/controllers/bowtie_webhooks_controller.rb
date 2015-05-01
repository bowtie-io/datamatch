class BowtieWebhooksController < ActionController::Base
  def create
    # Decode the data presented by the JWT
    hook, _attrs = JWT.decode(params[:jwt], Rails.configuration.bowtie_project_secret_key)

    # Find and delegate processing to the method responsible for this type of event
    event_processor = {
      'user.plan.updated'      => :user_plan_updated,
      'user.profile.tracked'   => :user_profile_tracked,
      'user.profile.updated'   => :user_profile_tracked,
      'user.profile.untracked' => :user_profile_untracked
    }[hook['event_type']]

    send(event_processor, hook) if event_processor

    # A 200 resonse code prevents this request from being retried
    head 200
  rescue JWT::DecodeError
    # A decode error indicates that the token is not valid and the request is not authorized
    head 403
  end

  private
  def user_plan_updated(hook)
    # Update an existing profile or create one
    profile.update_attributes!({
      plan: hook['data']['stripe_plan_id']
    })
  end

  def user_profile_tracked(hook)
    # Update an existing profile or create one
    profile_from_hook(hook).update_attributes!({
      tag_name_array: hook['data']['tags'],
      info:           hook['data']['info']
    })
  end

  def user_profile_untracked(hook)
    # Remove a profile that no longer exists
    Profile.destroy_all({
      bowtie_user_id: hook['user_id'],
      bowtie_project_id: hook['project_id']
    })
  end

  def profile_from_hook(hook)
    Profile.find_or_initialize_by({
      bowtie_user_id:     hook['user_id'],
      bowtie_project_id:  hook['project_id']
    })
  end
end
