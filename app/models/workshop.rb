class Workshop < ApplicationRecord
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
    return "awaiting_approval" if necessary_attrs_supplied?
    "draft"
  end

  private

  def necessary_attrs_supplied?
    values = [
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
      "facilitator"
    ].map {|attr| send(attr) }

    values.all?{|value| value.present? } && mentors.present?
  end
end

