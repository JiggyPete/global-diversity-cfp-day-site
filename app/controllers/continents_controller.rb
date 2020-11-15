class ContinentsController < ApplicationController
  skip_before_action :authenticate_user!

  class NoContinentException < Exception
  end

  def show
    requested_continent = params[:id]
    @continent = Continents.get(requested_continent)

    if @continent.blank?
      raise NoContinentException.new("No continent for: #{requested_continent}")
    end
  end
end
