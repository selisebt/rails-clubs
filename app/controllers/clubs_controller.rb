class ClubsController < ApplicationController
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
            turbo_stream.update("main-container", template: 'clubs/index'),
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
      if @club.update(club_params)
        format.html { redirect_to @club, notice: "Club was successfully updated." }
        format.json { render json: @club, include: :users }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @club.destroy
    respond_to do |format|
      format.html { redirect_to clubs_url, notice: "Club was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def search_members
    @query = params[:query]
    @users = User.where.not(id: @club.users.pluck(:id))
                 .where("email LIKE ? OR name LIKE ?", "%#{@query}%", "%#{@query}%")
                 .limit(10)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("search-results", partial: "search_results")
      end
      format.html { render partial: "search_results" }
    end
  end

  def add_member
    user = User.find(params[:user_id])

    if @club.memberships.create(user: user)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("club_members", partial: "clubs/member", locals: { user: user }),
            turbo_stream.update("search-results", "")
          ]
        end
        format.html { redirect_to @club, notice: "Member added successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial: "shared/flash", locals: { alert: "Failed to add member." }) }
        format.html { redirect_to @club, alert: "Failed to add member." }
      end
    end
  end

  def delete_member
    @club = Club.find(params[:id])
    membership = @club.memberships.find_by(user_id: params[:user_id])

    if membership&.destroy
      redirect_to @club, notice: "Member removed successfully."
    else
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
