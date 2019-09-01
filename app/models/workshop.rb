class Workshop < ApplicationRecord
  default_scope { where(year: nil) }

  validates :continent, :country, :city, presence: true
  validates_uniqueness_of :city, scope: :year

  MANDATORY_FIELDS_FOR_APPROVAL = [
    "continent",
    "country",
    "city",
    "venue_address",
    "google_maps_url",
    "start_time",
    "end_time",
    "time_zone",
    "ticketing_url",
    "organiser",
    "facilitator",
    "mentors"
  ]

  def self.previous_workshop_for(user)
    Workshop.unscoped.find_by(id: user.workshop_id, year: 2019)
  end

  def self.workshops_grouped_for_homepage
    result = Workshop.all.order(:continent, :country, :city).group_by(&:continent)

    result.keys.each do |continent|
      result[continent] = result[continent].group_by(&:country)
    end

    result
  end

  def awaiting_invitation_acceptance?(user)
    user.invitation_sent_at.present? && user.invitation_accepted_at.blank?
  end

  def signed_up_team
    result = []
    result << organiser unless organiser.nil? || awaiting_invitation_acceptance?(organiser)
    result << facilitator unless facilitator.nil? || awaiting_invitation_acceptance?(facilitator)
    mentors.each do |mentor|
      result << mentor unless mentor.nil? || awaiting_invitation_acceptance?(mentor)
    end

    result
  end

  def duplicate_for_2020(duplicated_by_user)
    workshop_for_2020 = duplicate_2019_workshop
    migrate_team_to! workshop_for_2020
    update_team_roles!(duplicated_by_user)

    workshop_for_2020
  end

  def migrate_team_to!(workshop_for_2020)
    organiser.update workshop: workshop_for_2020 if organiser.present?
    facilitator.update workshop: workshop_for_2020 if facilitator.present?

    mentors.each do |mentor|
      mentor.update workshop: workshop_for_2020
    end
  end

  def update_team_roles!(duplicated_by_user)
    if duplicated_by_user.facilitator?
      convert_orgraniser_to_mentor
      convert_facilitator_to_orgraniser(duplicated_by_user)
    end

    if duplicated_by_user.mentor?
      convert_orgraniser_to_mentor
      convert_mentor_to_orgraniser(duplicated_by_user)
    end
  end

  def organiser
    @organiser ||= User.where(workshop_id: id, organiser: true).first
  end

  def facilitator
    @facilitator ||= User.where(workshop_id: id, facilitator: true).first
  end

  def mentors
    @mentors ||= User.where(workshop_id: id, mentor: true)
  end

  def status
    return "draft" unless necessary_attrs_supplied?
    "pending"
  end

  def percentage_complete
    return 100 if status != "draft"

    ((number_of_mandatory_fields_complete.to_f/number_of_mandatory_fields)*100).round
  end

  private

  def number_of_mandatory_fields
    MANDATORY_FIELDS_FOR_APPROVAL.length
  end

  def number_of_mandatory_fields_complete
    mandatory_values.select{|value| value.present? }.length
  end

  def necessary_attrs_supplied?
    mandatory_values.all?{|value| value.present? }
  end

  def mandatory_values
    MANDATORY_FIELDS_FOR_APPROVAL.map {|attr| send(attr) }
  end

  def duplicate_2019_workshop
    result = self.dup
    result.year = nil
    result.ticketing_url = nil
    result.save!

    result
  end

  def convert_facilitator_to_orgraniser(duplicated_by_user)
    duplicated_by_user.update_attributes(
      organiser: true,
      facilitator: false
    )
  end

  def convert_mentor_to_orgraniser(duplicated_by_user)
    duplicated_by_user.update_attributes(
      organiser: true,
      mentor: false
    )
  end

  def convert_orgraniser_to_mentor
    organiser.update_attributes(
      organiser: false,
      mentor: true
    )
  end

end

