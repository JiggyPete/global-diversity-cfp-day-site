class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    if current_workshop.present?
      redirect_to workshop_path(current_workshop)
    end

    @workshop = Workshop.new
  end

  def edit
  end

  def create
    if current_workshop.present?
      redirect_to workshop_path(current_workshop)
    end

    @workshop = Workshop.new(workshop_params)
    current_user.workshop = @workshop

    respond_to do |format|
      if @current_user.save
        format.html { redirect_to @workshop, notice: 'Workshop was successfully created.' }
        format.json { render :show, status: :created, location: @workshop }
      else
        format.html { render :new }
        format.json { render json: @workshop.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @workshop.update(workshop_params)
        format.html do
          flash[:success] = 'Workshop was successfully updated.'
          redirect_to @workshop
        end
        format.json { render :show, status: :ok, location: @workshop }
      else
        format.html do
          flash[:notice] = 'Workshop failed to updated.'
         render :edit
        end
        format.json { render json: @workshop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @workshop.destroy
    respond_to do |format|
      format.html { redirect_to workshops_url, notice: 'Workshop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_workshop
    @workshop = current_workshop
  end

  def workshop_params
    params.require(:workshop).permit(:continent, :country, :city, :venue_address, :google_maps_url, :start_time, :end_time, :time_zone, :ticketing_url, :organiser_id, :facilitator_id, :notes)
  end
end
