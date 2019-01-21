class ProposalsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def show
    template = 'how-does-javascript-math'
    template = params["id"] if params["id"].present?

    render template
  end
end
