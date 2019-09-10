class AddWorkshopAttendeeStats < ActiveRecord::Migration[5.1]
  def change
    add_column :workshops, :number_of_sign_ups, :integer, default: 0
    add_column :workshops, :number_of_attendees, :integer, default: 0
  end
end
