class AnnouncementsController < ApplicationController
  def index
    @club = club
    @announcements = club.announcements
    respond_to do |format|
      format.html { render :index, layout: "application" }
      format.json { render json: @announcements }
    end
  end

  def show
    @announcement = announcement
    respond_to do |format|
      format.html { render :show, layout: "application" }
      format.json { render json: @announcement }
    end
  end

  def new
    @club = club
    @announcement = Announcement.new(club_id: club.id)
    respond_to do |format|
      format.html { render :new, layout: "application" }
    end
  end

  def create
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
    @announcement = announcement
    @club = announcement.club
    @cancel_path = params[:cancel_path]
    respond_to do |format|
      format.html { render :edit, layout: "application" }
    end
  end

  def destroy
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
