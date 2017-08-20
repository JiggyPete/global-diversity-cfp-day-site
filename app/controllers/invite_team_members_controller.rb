class InviteTeamMembersController < ApplicationController
  def create
    User.invite!(user_params.merge(workshop: current_workshop))

    redirect_to workshop_path(current_workshop)
  end

  private

  def user_params
    params.permit(:email, :facilitator, :mentor)
  end
end
