class IncidentsController < ApplicationController
  def index
    @incidents = Incident.all.sort{|i| i.created_at}
  end

  def new
    @incident = Incident.new
  end

  def create
    @incident = Incident.new(incident_params)
    @incident.user = current_user

    respond_to do |format|
      if @incident.save
        format.html do
          AdminMailer.incident_created(@incident).deliver
          redirect_to incidents_path, notice: 'Incident was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  def show
    redirect_to incidents_path unless current_user.admin?
    @incident = Incident.find(params[:id])
  end

  private

  def incident_params
    params.require(:incident).permit(
      :person_reporting,
      :contact_details_of_person_reporting,
      :approximate_time_of_incident,
      :info_about_offender,
      :contact_details_about_offender,
      :violation,
      :circumstances,
      :other_people_involved,
      :team_members_present
    )
  end

end
