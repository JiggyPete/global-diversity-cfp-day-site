class CocTrainingsController < ApplicationController
  TRAINING_TYPES = {
    "video" => "https://www.dropbox.com/s/ygdwxxpaum63adv/CoC%20Training%20Video.mp4?dl=0",
    "audio" => "https://www.dropbox.com/s/lcezb1yoag1whuh/CoC%20Training%20Audio.mp3?dl=0",
    "pdf" => "https://www.dropbox.com/s/upv72s8jivlz4sm/CoC%20Training.pdf?dl=0"
  }

  def new
  end

  def create
    if params[:coc_training_downloaded]
      current_user.update coc_training_downloaded: true, coc_training_type: params[:coc_training_type]
      redirect_to TRAINING_TYPES[params[:coc_training_type]]
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
  end

  private

  def user_params
    params.permit(:email, :organiser, :facilitator, :mentor)
  end
end
