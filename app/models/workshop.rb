class Workshop < ApplicationRecord
  belongs_to :organiser, class_name: "User"
end
