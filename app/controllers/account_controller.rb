class AccountController < ApplicationController
  def edit
  end

  def update
    if current_user.update update_params
      binding.pry
      redirect_to workshop_landing_page_for(current_user)
    else
      binding.pry
      render :edit
    end
  end

  private

  def update_params
    params.require(:user).permit(:email, :full_name, :biography, :picture_url, :run_workshop_explaination, :organiser, :displayed_email, :displayed_twitter, :displayed_github)
  end
end
