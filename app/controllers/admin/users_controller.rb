module Admin
  class UsersController < ApplicationController
    before_action :is_admin

    def index
      @users = User.all
    end

    def edit
      @user = User.find params[:id]
    end

    def update
      @user = User.find params[:id]
      if @user.update update_params
        flash[:success] = "#{@user.full_name} successfully updated"
        redirect_to admin_users_path
      else
        flash[:alert] = "Error updating user: #{@user.full_name}"
        render :edit
      end
    end

    def destroy
      @user = User.find params[:id]
      if @user.destroy
        flash[:success] = "#{@user.full_name} successfully deleted"
      else
        flash[:alert] = "Error deleting user: #{@user.full_name}"
      end

      redirect_to admin_users_path
    end

    private

    def is_admin
      redirect_to root_path unless current_user.admin?
    end

    def update_params
      params.require(:user).permit(:email, :full_name, :biography, :picture_url, :run_workshop_explaination, :organiser, :displayed_email, :displayed_twitter, :displayed_github)
    end

  end
end
