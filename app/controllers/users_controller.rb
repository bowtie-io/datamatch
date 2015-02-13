class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # potential matches
  def index
    binding.pry
    all_users = current_project.users
    potential_matches = all_users.delete(current_user)
    render json: potential_matches.map(&:id)
  end

end
