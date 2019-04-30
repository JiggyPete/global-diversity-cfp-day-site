class EventsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @workshop = Workshop.find params[:id]
  end

  def berlin
  end
end
