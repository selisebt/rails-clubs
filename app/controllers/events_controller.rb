class EventsController < ApplicationController
  before_action :set_club
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = @club.events.order(from: :asc)
    respond_to do |format|
      format.html { render :index, layout: "application" }
    end
  end

  def show
    respond_to do |format|
      format.html { render :show, layout: "application" }
    end
  end

  def new
    @event = @club.events.build(status: 'scheduled')
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
    @event = @club.events.build(event_params)

    if @event.save
      respond_to do |format|
        # format.turbo_stream
        format.html { redirect_to club_events_path(@club), notice: "Event was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      respond_to do |format|
        # format.turbo_stream
        format.html { redirect_to club_events_path(@club), notice: "Event was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      # format.turbo_stream
      format.html { redirect_to club_events_path(@club), notice: "Event was successfully deleted." }
    end
  end

  private

  def set_club
    @club = Club.find(params[:club_id])
  end

  def set_event
    @event = @club.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:description, :name, :from, :to, :status)
  end
end
