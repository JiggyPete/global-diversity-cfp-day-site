class EventsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    workshop = Workshop.find params[:id]
    if workshop.ticketing_url.present? || current_user.present?
      @workshop = workshop
    else
      raise Exception.new("User trying to access event when tickets are not available")
    end
  end
end
