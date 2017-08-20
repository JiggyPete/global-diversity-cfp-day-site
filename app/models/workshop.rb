class Workshop < ApplicationRecord
  belongs_to :organiser, class_name: "User"
  belongs_to :facilitator, class_name: "User", optional: true
end
