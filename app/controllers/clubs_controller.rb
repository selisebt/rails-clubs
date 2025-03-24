class ClubsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :set_club, only: %i[show edit update destroy search_members add_member]

  def index
    @clubs = current_user.clubs
    respond_to do |format|
      format.html { render :index, layout: "application" }
      format.json { render json: @clubs, include: :users }
    end
  end

  def show
    respond_to do |format|
      format.html { render :show, layout: "application" }
      format.json { render json: @club, include: :users }
    end
  end

  def new
    @club = Club.new
    respond_to do |format|
      format.html { render :new, layout: "application" }
    end
  end

  def edit
    respond_to do |format|
      format.html { render :edit, layout: "application" }
    end
  end

  def create
    raise StandardError, "You are not authorized to create a club" unless [ "admin" ].include?(current_user.role.name)
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        Membership.create!(
          club_id: @club.reload.id,
          user_id: current_user.id
        )
        @clubs = current_user.clubs
        flash[:notice] = "Club created successfully."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "clubs/index"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Club created successfully.", type: "success" })
          ]
        end
        format.json { render json: @club, status: :created, include: :users }
      else
        flash[:error] = @club.errors.full_messages.join(", ")
        format.html { render :new, layout: "application" }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      flash[:notice] = "Club updated successfully."
      if @club.update(club_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "clubs/show"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Club created successfully.", type: "success" })
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @club.destroy
    respond_to do |format|
      @clubs = current_user.clubs
      flash[:notice] = "Club deleted successfully."
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("main-container", template: "clubs/index"),
          turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Club created successfully.", type: "success" })
        ]
      end
      format.json { head :no_content }
    end
  end

  def search_members
    @query = params[:query]
    @users = User.where.not(id: @club.users.pluck(:id))
                 .where("email LIKE ? OR name LIKE ?", "%#{@query}%", "%#{@query}%")
                 .limit(10)
    respond_to do |format|
      format.html { render partial: "search_results" }
    end
  end

  def add_member
    user = User.find(params[:user_id])

    if @club.memberships.create(user: user)
      respond_to do |format|
        flash[:notice] = "Club member added successfully."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("club_members", partial: "clubs/member", locals: { user: user }),
            turbo_stream.update("search-results", ""),
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.replace("clubs_user_count", partial: "clubs/member_count"),
            turbo_stream.replace("user_stats_count", partial: "clubs/member_stats_count")
          ]
        end
      end
    else
      flash[:error] = "Club member could not be added."
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial: "shared/flash") }
      end
    end
  end

  def delete_member
    @club = Club.find(params[:id])
    membership = @club.memberships.find_by(user_id: params[:user_id])

    if membership&.destroy
      flash[:notice] = "Club member removed successfully."
      redirect_to @club, notice: "Member removed successfully."
    else
      flash[:error] = "Club member could not be removed. #{membership.errors.full_messages.join(", ")}"
      redirect_to @club, alert: "Failed to remove member."
    end
  end

  private

  def set_club
    @club = Club.find(params[:id])
  end

  def club_params
    params.require(:club).permit(:name, :description)
  end
end
