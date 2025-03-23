class Users::InvitationsController < Devise::InvitationsController
  def create
    if params[:csv]
      csv_data = params[:csv].read
      BulkInviteUsersJob.perform_later(csv_data, current_user.id)

      @pagy, @users = pagy(User.where.not(id: current_user.id), limit: 10)
      @roles = Role.all
      flash[:notice] = "User bulk invite queued."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("all_users", template: "users/index", layout: false)
          ]
        end
        format.json { render json: { message: "User bulk invite queued." } }
      end

    else
      self.resource = invite_resource
      resource_invited = resource.errors.empty?

      yield resource if block_given?

      if resource_invited
        @pagy, @users = pagy(User.where.not(id: current_user.id), limit: 10)
        @roles = Role.all
        flash[:notice] = "User invited successfully."
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("flash", partial: "shared/flash"),
              turbo_stream.update("all_users", template: "users/index", layout: false)
            ]
          end
          format.json { render json: { done: true } }
        end
      else
        respond_with(resource)
      end
    end
  end

  private

  def invite_params
    params.require(:user).permit(:name, :email, :role_id)
  end
end
