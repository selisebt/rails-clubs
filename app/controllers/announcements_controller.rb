class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.all
    respond_to do |format|
      format.html
      format.json { render json: @announcements }
    end
  end

  def show
    @announcement = announcement
    respond_to do |format|
      format.html
      format.json { render json: @announcement }
    end
  end

  def new
    @announcement = Announcement.new
    respond_to do |format|
      format.html
    end
  end

  def create
    Announcement.create!(announcement_params)
    respond_to do |format|
      format.html
      format.json { render json: { done: true } }
    end
  end

  def update
    announcement.update!(announcement_params)
    respond_to do |format|
      format.html
      format.json { render json: { done: true } }
    end
  end

  def destroy
    announcement.destroy!
    respond_to do |format|
      format.html
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
end
