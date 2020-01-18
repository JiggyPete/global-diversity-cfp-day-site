class CelebrateController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to celebrate_url
  end
end
