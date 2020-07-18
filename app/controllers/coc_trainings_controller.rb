class CocTrainingsController < ApplicationController
  TRAINING_TYPES = {
    "video" => "https://www.dropbox.com/s/oi3uvm58x78q3z9/CoC%20Training%20Video.mp4?dl=0",
    "audio" => "https://www.dropbox.com/s/w2tzo9tofwtmtcl/CoC%20Training%20Audio.mp3?dl=0",
    "pdf" => "https://www.dropbox.com/s/tjfyuw7gn4wcf0v/CoC%20Training.pdf?dl=0"
  }

  YOUR_WORKSHOP_TYPES = {
    "video" => "https://www.dropbox.com/s/t7oi0nimljfnudb/Global%20Diversity%20CFP%20Day%20-%20Your%20Workshop%20%28improved%20audio%29.mp4?dl=0",
    "audio" => "https://www.dropbox.com/s/kymjmg8odu2vm8o/Your%20Workshop.mp3?dl=0",
    "doc" => "https://docs.google.com/document/d/1VEDWRYPsU3C4OS5XDB1GA7yB0xuZ2Fftka0udaGLZb0/edit?usp=sharing"
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
      redirect_to YOUR_WORKSHOP_TYPES[params[:your_workshop_type]]
    else
      redirect_to workshop_path(current_workshop)
    end
  end

  private

  def user_params
    params.permit(:email, :organiser, :facilitator, :mentor)
  end
end
