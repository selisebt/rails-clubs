class EventsController < ApplicationController
  before_action :set_club
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    permit!(current_user, "event", "read")
    @events = @club.events.order(from: :asc)
    respond_to do |format|
      format.html { render :index, layout: "application" }
    end
  end

  def show
    permit!(current_user, "event", "read")
    respond_to do |format|
      format.html { render :show, layout: "application" }
    end
  end

  def new
    permit!(
      current_user,
      "event",
      "create",
      @club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @event = @club.events.build(status: "scheduled")
    respond_to do |format|
      format.html { render :new, layout: "application" }
    end
  end

  def edit
    permit!(
      current_user,
      "event",
      "update",
      @club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    respond_to do |format|
      format.html { render :edit, layout: "application" }
    end
  end

  def create
    permit!(
      current_user,
      "event",
      "create",
      @club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @event = @club.events.build(event_params)
    @events = @club.events

    if @event.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Event created successfully."
          render turbo_stream: [
            turbo_stream.update("main-container", template: "events/index"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to club_events_path(@club), notice: "Event created successfully" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:error] = @event.errors.full_messages.join(", ")
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
      end
    end
  end

  def update
    permit!(
      current_user,
      "event",
      "update",
      @club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    if @event.update(event_params)
      @events = @club.events
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Event updated successfully."
          render turbo_stream: [
            turbo_stream.update("main-container", template: "events/index"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to club_events_path(@club), notice: "Event was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    permit!(
      current_user,
      "event",
      "delete",
      @club.memberships.find_by(user_id: current_user.id)&.manager?
    )
    @event.destroy
    respond_to do |format|
      @events = @club.events
      flash.now[:notice] = "Event deleted successfully."
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("main-container", template: "events/index"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.html { redirect_to club_events_path(@club), notice: "Event was successfully destroyed." }
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
