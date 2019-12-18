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
    "ticketing_url",
    "organisers",
    "facilitators",
    "mentors"
  ]

  def self.previous_workshop_for(user)
    Workshop.unscoped.find_by(id: user.workshop_id, year: 2019)
  end

  def self.group_by_continent_and_country(workshops)
    result = workshops.order(:continent, :country, :city).group_by(&:continent)

    result.keys.each do |continent|
      result[continent] = result[continent].group_by(&:country)
      result[continent].keys.each do |country|
        result[continent][country] = result[continent][country].sort { |a, b| a.city <=> b.city }
      end
    end

    result
  end

  def self.newest_workshops_by_continent
    Workshop.group_by_continent_and_country(Workshop.all.order(created_at: :desc).limit(5))
  end

  def self.workshops_grouped_for_homepage
    Workshop.group_by_continent_and_country(Workshop.all)
  end

  def awaiting_invitation_acceptance?(user)
    user.invitation_sent_at.present? && user.invitation_accepted_at.blank?
  end

  def signed_up_team
    result = []
    organisers.each do |organiser|
      result << organiser unless organiser.nil? || awaiting_invitation_acceptance?(organiser)
    end

    facilitators.each do |facilitator|
      result << facilitator unless facilitator.nil? || awaiting_invitation_acceptance?(facilitator)
    end

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
    organisers.each do |organiser|
      organiser.update workshop: workshop_for_2020 if organiser.present?
    end

    facilitators.each do |facilitator|
      facilitator.update workshop: workshop_for_2020
    end

    mentors.each do |mentor|
      mentor.update workshop: workshop_for_2020
    end
  end

  def update_team_roles!(duplicated_by_user)
    if duplicated_by_user.facilitator?
      convert_facilitator_to_orgraniser(duplicated_by_user)
    end

    if duplicated_by_user.mentor?
      convert_mentor_to_orgraniser(duplicated_by_user)
    end
  end

  def organiser
    @organiser ||= User.where(workshop_id: id, organiser: true).first
  end

  def organisers
    User.where(workshop_id: id, organiser: true)
  end

  def facilitators
    @facilitators ||= User.where(workshop_id: id, facilitator: true)
  end

  def mentors
    @mentors ||= User.where(workshop_id: id, mentor: true)
  end

  def status
    return "draft" unless necessary_attrs_supplied?
    "pending"
  end

  private

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
end

