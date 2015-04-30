Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :dm_users, controller: "users"
  resources :projects
  resources :details
  resources :matches

  post '/webhooks/bowtie' => 'bowtie_webhooks#create'
end
