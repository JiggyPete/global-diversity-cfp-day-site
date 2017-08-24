module ApplicationHelper
  def workshop_landing_page_for(user)
    user.workshop.present? ?  workshop_path(user.workshop) : new_workshop_path
  end

  def user_name(user)
    user.full_name? ? user.full_name : user.email
  end
end
