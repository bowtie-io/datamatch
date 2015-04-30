Rails.application.routes.draw do
  # Completed matches for the current user
  get '/matches'            => 'matches#index'

  # Completed matches for the current user that the user has not been notified of
  get '/matches/unnotified' => 'matches#unnotified'

  # Potential matches to display to the current user for selection
  get '/matches/potential'  => 'matches#potential'

  # Create a new match for the current user
  post '/matches'           => 'matches#create'

  # Handle user profile data updates and any other BowTie web hooks
  post '/webhooks/bowtie' => 'bowtie_webhooks#create'
end
