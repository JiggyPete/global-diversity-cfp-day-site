module ApplicationHelper
  def workshop_landing_page_for(user)
    return admin_users_path if user.admin?

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

  def celebrate_url
    "https://goo.gl/forms/2kN6msbKrLhb2dIc2"
  end

  def sign_up_data_supplied_by_workshops
    workshops_with_attendee_data.select{|w| w.number_of_sign_ups.present? &&  w.number_of_sign_ups != 0}.length
  end

  def attendee_data_supplied_by_workshops
    workshops_with_attendee_data.length
  end

  def workshops_with_attendee_data
    Workshop.all.select{|w| w.number_of_attendees.present? &&  w.number_of_attendees != 0}
  end

  def number_of_sign_ups
    workshops_with_attendee_data.map(&:number_of_sign_ups).compact.sum
  end

  def number_of_attendees
    workshops_with_attendee_data.map(&:number_of_attendees).compact.sum
  end

  def average_attendees_per_workshop
    number_of_attendees / attendee_data_supplied_by_workshops
  end

  def community_partner_link(name, url, filename)
    link_to url do
      image_tag("community-groups/#{filename}", alt: name, class: "community-group")
    end
  end

  def sponsor_link(name, url, filename)
    link_to url do
      image_tag("sponsors/#{filename}", alt: name, class: "community-group")
    end
  end
end
