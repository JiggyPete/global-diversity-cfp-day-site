module ApplicationHelper
  def workshop_landing_page_for(user)
    return admin_workshops_path if user.admin?

    user.workshop.present? ?  workshop_path(user.workshop) : new_workshop_path
  end

  def user_name(user)
    user.full_name? ? user.full_name : user.email
  end

  def awaiting_invitation_acceptance?(user)
    user.invitation_sent_at.present? && user.invitation_accepted_at.blank?
  end

  def random_jumbo_pic_class
    [
      "chad",
      "jaycee",
      "jem",
      "kim",
      "livi",
      "sareh",
    ].sample
  end
end
