Rails.application.routes.draw do
  # Completed matches for the current user
  get '/matches/confirmed' => 'matches#confirmed'

  # Confirm receipt of match and move on to the next user
  post '/matches/:matched_profile_id/pass' => 'matches#pass'

  # Confirm receipt of match and move on to the next user
  post '/matches/:matched_profile_id/accept' => 'matches#accept'

  # Completed matches for the current user that the user has not been notified of
  get '/matches/unnotified' => 'matches#unnotified'

  # Confirm notification for a completed match so the user doesn't get notified again
  post '/matches/:matched_profile_id/confirm_notification' => 'matches#confirm_notification'

  # Potential matches to display to the current user for selection
  get '/matches/potential' => 'matches#potential'

  # Handle user profile data updates and any other BowTie web hooks
  post '/webhooks/bowtie' => 'bowtie_webhooks#create'
end
