class Workshop < ApplicationRecord
  def organiser
    @organiser ||= User.where(workshop_id: id, organiser: true).first
  end

  def facilitator
    @facilitator ||= User.where(workshop_id: id, facilitator: true).first
  end
end
