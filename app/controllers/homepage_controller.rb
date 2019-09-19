class HomepageController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @workshops = Workshop.workshops_grouped_for_homepage
    @newest_workshops = Workshop.newest_workshops_by_continent
  end
end
