class Users::InvitationsController < Devise::InvitationsController
  def create
    if params[:csv]
      csv_data = params[:csv].read
      BulkInviteUsersJob.perform_later(csv_data)

      respond_to do |format|
        format.html { redirect_to after_invite_path_for(resource), notice: "Bulk invitations have been queued for processing." }
        format.json { render json: { message: "Bulk invitations have been queued for processing." }, status: :ok }
      end
    else
      super
    end
  end
end
