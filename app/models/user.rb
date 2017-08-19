class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :workshop, foreign_key: 'organiser_id', class_name: "Workshop"

  validates_presence_of :full_name,
                        :biography,
                        :picture_url,
                        :run_workshop_explaination

  validates :picture_url, :url => true
end
