class ClubsController < ApplicationController
  before_action :set_club, only: [ :show, :edit, :update, :destroy ]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @clubs, include: :users }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @club, include: :users }
    end
  end

  def new
    @club = Club.new
  end

  def edit
  end

  def create
    @club = Club.new(club_params)
    
    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: "Club was successfully created." }
        format.json { render json: @club, status: :created, include: :users }
      else
        format.html { render :new, status: :unprocessable_entity }
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

  private

  def set_club
    @club = Club.find(params[:id])
  end

  def set_clubs
    @clubs = Club.all
  end

  def club_params
    params.require(:club).permit(:name, :description)
  end
end
