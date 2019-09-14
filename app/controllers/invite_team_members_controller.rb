class InviteTeamMembersController < ApplicationController
  def create
    User.invite!(user_params.merge(workshop: current_workshop))

    flash[:notice] = "Invitation has been sent"
    redirect_to workshop_path(current_workshop)
  end

  private

  def user_params
    params.permit(:email, :organiser, :facilitator, :mentor)
  end
end
