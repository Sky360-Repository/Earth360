ActiveAdmin.register UserTrack do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :track_id, :requested_at, :completed_at, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :track_id, :requested_at, :completed_at, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
