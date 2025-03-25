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
    announcement = Announcement.new(announcement_params)
    @club = club
    @announcements = club.announcements
    respond_to do |format|
      if announcement.save
        flash[:notice] = "Announcement created successfully."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "announcements/index"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Club created successfully.", type: "success" })
          ]
        end
        format.json { render json: { done: true } }
      else
        flash[:error] = announcement.errors.full_messages.join(", ")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("main-container", template: "announcements/index"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Club created successfully.", type: "success" })
          ]
        end
      end
    end
  end

  def update
    announcement.update!(announcement_params)
    respond_to do |format|
      format.html { render :show, layout: "application" }
      format.json { render json: { done: true } }
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
      format.html { render :index, layout: "application" }
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
