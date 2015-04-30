Rails.application.routes.draw do
  resources :matches
  post '/webhooks/bowtie' => 'bowtie_webhooks#create'
end
