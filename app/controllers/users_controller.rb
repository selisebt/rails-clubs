class UsersController < ApplicationController
  def index
    @users = User.all
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
