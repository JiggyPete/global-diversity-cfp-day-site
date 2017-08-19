class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_presence_of :full_name,
                        :biography,
                        :picture_url,
                        :run_workshop_explaination

  validates :picture_url, :url => true
end
