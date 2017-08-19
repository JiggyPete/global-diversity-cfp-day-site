class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :full_name, :biography, :picture_url, :run_workshop_explaination, :organiser, :displayed_email, :displayed_twitter, :displayed_github])
  end
end
