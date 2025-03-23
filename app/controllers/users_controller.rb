class UsersController < ApplicationController

  def index
    @users = User.all
      .search_by_name(params[:query])
      .search_by_email(params[:query])

    @pagy, @users = pagy(@users, items: 10)
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
    @user = user
  end

  def update
    user.update!(user_params)
    respond_to do |format|
      format.html
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

  def user_params
    params.require(:user).permit(:name)
  end
end
