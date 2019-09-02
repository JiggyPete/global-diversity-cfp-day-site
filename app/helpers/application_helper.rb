module ApplicationHelper
  def workshop_landing_page_for(user)
    return admin_workshops_path if user.admin?

    return workshop_path(user.workshop) if user.workshop.present?
    return workshop_new_duplicate_path(user.workshop_id) if Workshop.previous_workshop_for( user ).present?

    new_workshop_path
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

  def twitter_url(user)
    "http://twitter.com/" + user.displayed_twitter
  end

  def twitter_link(twitter_handle, text)
    link_to text, "https://twitter.com/#{twitter_handle}", target: "_blank"
  end

  def coc_completed(user)
    user.coc_training_complete? ? "✅" : "🚨"
  end
end
