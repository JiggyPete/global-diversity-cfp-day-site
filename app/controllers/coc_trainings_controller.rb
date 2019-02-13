class CocTrainingsController < ApplicationController
  def new
  end

  def create
    if params[:coc_training_downloaded]
      current_user.update coc_training_downloaded: true
      redirect_to "https://www.dropbox.com/s/6vklilk6up1v8hx/CoC%20Training%20Audio.mp3"
    elsif params[:coc_training_complete]
      flash[:notice] = "Thank you for completing Code of Conduct Training"
      current_user.update coc_training_complete: true
      redirect_to new_coc_training_path
    elsif params[:call_downloaded]
      current_user.update call_downloaded: true
      redirect_to "https://www.dropbox.com/s/em65115ic721p95/gdcfpday%20prep.mp4?dl=0"
    else
      redirect_to workshop_path(current_workshop)
    end
    # :call_downloaded
    # :coc_training_downloaded
    # :coc_training_complete


  end

  private

  def user_params
    params.permit(:email, :facilitator, :mentor)
  end
end
