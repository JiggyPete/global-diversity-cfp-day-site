class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :workshop, foreign_key: 'organiser_id', class_name: "Workshop"

  validates_presence_of :full_name,
                        :biography,
                        :picture_url,
                        :run_workshop_explaination

  validates :picture_url, :url => true

  def workshop
    return Workshop.where(facilitator_id: id).first if facilitator?
    return Workshop.where(organiser_id: id).first if organiser?
  end
end
