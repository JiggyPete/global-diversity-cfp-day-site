class ProposalsController < ApplicationController
  def index
  end

  def show
    template = 'how-does-javascript-math'
    render template
  end
end
