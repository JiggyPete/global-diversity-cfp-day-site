class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :workshop, optional: true

  validates_presence_of :full_name,
                        :biography,
                        :picture_url,
                        :run_workshop_explaination

  validates :picture_url, :url => true
end
