class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :workshop, optional: true

  validates_presence_of :full_name,
                        :biography,
                        :picture_url,
                        :run_workshop_explaination

  validates :picture_url, :url => true

  def awaiting_invite_acceptance?
    direct_signup = !invitation_created_at? && !invitation_accepted_at?
    return false if direct_signup

    invitation_created_at? && !invitation_accepted_at?
  end
end
