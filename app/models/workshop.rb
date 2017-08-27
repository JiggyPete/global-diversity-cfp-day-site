class Workshop < ApplicationRecord

  validates :continent, :country, :city, presence: true

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

  def self.workshops_grouped_for_homepage
    result = Workshop.all.order(:continent, :country, :city).group_by(&:continent)

    result.keys.each do |continent|
      result[continent] = result[continent].group_by(&:country)
    end

    result
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
end

