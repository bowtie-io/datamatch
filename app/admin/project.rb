ActiveAdmin.register Project do
  permit_params :name, :auth_domain, :user_details, :match_types, :global_match, :active



end
