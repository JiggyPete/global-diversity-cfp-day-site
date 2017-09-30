module Admin
  class WorkshopsController < ApplicationController
    before_action :is_admin

    def index
      @workshops = Workshop.workshops_grouped_for_homepage
    end

    private

    def is_admin
      redirect_to root_path unless current_user.admin?
    end
  end
end
