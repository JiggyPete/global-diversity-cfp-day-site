class InviteTeamMembersController < ApplicationController
  def create
    user = User.invite!(user_params)
    current_workshop.update(facilitator: user)

    redirect_to :back
  end

  private

  def user_params
    params.permit(:email, :facilitator)
  end
end
