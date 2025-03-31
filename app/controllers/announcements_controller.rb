class AnnouncementsController < ApplicationController
  def index
    permit!(current_user, "announcement", "read")
    @club = club
    @announcements = club.announcements
    respond_to do |format|
      format.html { render :index, layout: "application" }
      format.json { render json: @announcements }
    end
  end

  def show
    permit!(current_user, "announcement", "read")
    @announcement = announcement
    respond_to do |format|
      format.html { render :show, layout: "application" }
      format.json { render json: @announcement }
    end
  end

  def new
    permit!(
      current_user,
      "announcement",
      "create",
      club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @club = club
    @announcement = Announcement.new(club_id: club.id)
    respond_to do |format|
      format.html { render :new, layout: "application" }
    end
  end

  def create
    permit!(
      current_user,
      "announcement",
      "create",
      club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @club = club
    @announcements = club.announcements
    respond_to do |format|
      if Announcements::CreateAnnouncement.new(announcement_params).create
        flash.now[:notice] = "Announcement created successfully."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "announcements/index"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.json { render json: { done: true } }
      else
        flash.now[:error] = "Please check your input."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "announcements/index"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
      end
    end
  end

  def update
    permit!(
      current_user,
      "announcement",
      "update",
      club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    respond_to do |format|
      if announcement.update(announcement_params)
        flash.now[:notice] = "Announcement updated successfully."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "announcements/show"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.json { render json: { done: true } }
      else
        flash.now[:error] = announcement.errors.full_messages.join(", ")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "announcements/show"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
      end
    end
  end

  def edit
    permit!(
      current_user,
      "announcement",
      "update",
      announcement.club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @announcement = announcement
    @club = announcement.club
    @cancel_path = params[:cancel_path]
    respond_to do |format|
      format.html { render :edit, layout: "application" }
    end
  end

  def destroy
    permit!(
      current_user,
      "announcement",
      "delete",
      announcement.club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @club = announcement.club
    announcement.destroy!
    @announcements = club.announcements
    respond_to do |format|
      flash.now[:notice] = "Announcement updated successfully."
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("main-container", template: "announcements/index"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.json { render json: { done: true } }
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:title, :message, :priority, :club_id)
  end

  def announcement
    @announcement ||= Announcement.find(params[:id])
  end

  def club
    @club ||= Club.find(params[:club_id] || announcement_params[:club_id])
  end
end
