class UsersController < ApplicationController

  def index
    @pagy, @users = pagy(users, limit: 10)
    @roles = Role.all

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    @user = user
    respond_to do |format|
      format.html
      format.json { render json: { user: user } }
    end
  end

  def edit
    respond_to do |format|
      format.html { render partial: "edit_user", locals: { user: user } }
    end
  end

  def update
    user.update!(user_params)
    @pagy, @users = pagy(users, limit: 10)
    @roles = Role.all
    respond_to do |format|
      format.html { render :index, layout: false }
      format.json { render json: { done: true } }
    end
  end

  def destroy
    user.destroy!
    respond_to do |format|
      format.html
      format.json { render json: { done: true } }
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def users
    User.all
        .search_by_name(params[:query])
        .search_by_email(params[:query])
        .where.not(id: current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :role_id)
  end
end
