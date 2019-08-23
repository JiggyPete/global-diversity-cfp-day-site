class SuccessStory < ApplicationRecord

  validates_presence_of :full_name,
    :profile_picture_url,
    :email_address,
    :talk_title,
    :event_name,
    :event_start_date,
    :event_end_date,
    :premission_for_public_use,
    :approved

  validates :profile_picture_url, :url => true

end
