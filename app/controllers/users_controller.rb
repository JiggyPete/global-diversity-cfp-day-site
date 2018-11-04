class UsersController < ApplicationController
  def destroy
    if user_belongs_to_workshop?
      @user.destroy
      flash[:notice] = "User successfully deleted"
    else
      flash[:notice] = "Error deleting user"
    end
    redirect_to workshop_path(current_workshop)
  end

  private

  def user_belongs_to_workshop?
    @user = User.find(params[:id])
    ([current_workshop.facilitator] + current_workshop.mentors).include? @user
  end
end
