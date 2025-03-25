class UsersController < ApplicationController
  def index
    permit!(current_user, "user", "read")
    @pagy, @users = pagy(users, limit: 10, request_path: users_path)
    @roles = Role.all

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("all_users", partial: "users/user_list")
      end
      format.json { render json: @users }
    end
  end

  def show
    permit!(current_user, "user", "read")
    @user = user
    respond_to do |format|
      format.html
      format.json { render json: { user: user } }
    end
  end

  def edit
    permit!(current_user, "user", "update")
    respond_to do |format|
      format.html { render partial: "edit_user", locals: { user: user } }
    end
  end

  def delete
    permit!(current_user, "user", "delete")
    respond_to do |format|
      format.html { render partial: "delete_user", locals: { user: user } }
    end
  end

  def update
    permit!(current_user, "user", "update")
    user.update!(user_params)
    @pagy, @users = pagy(users, limit: 10, request_path: users_path)
    @roles = Role.all
    respond_to do |format|
      format.html { render :index, layout: false }
      format.json { render json: { done: true } }
    end
  end

  def destroy
    permit!(current_user, "user", "delete")
    user.destroy!
    @pagy, @users = pagy(users, limit: 10, request_path: users_path)
    @roles = Role.all

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("all_users", partial: "users/user_list"),
          turbo_stream.update("flash", partial: "shared/flash", locals: { message: "User deleted successfully", type: "success" })
        ]
      end
      format.html { redirect_to users_path, notice: "User deleted successfully" }
      format.json { render json: { done: true } }
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def users
    User.all
        .search(params[:query])
        .where.not(id: current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :role_id)
  end
end
