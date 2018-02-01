class AddIncidentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.references :user
      t.string :person_reporting
      t.string :contact_details_of_person_reporting
      t.time :approximate_time_of_incident
      t.string :info_about_offender
      t.string :contact_details_about_offender
      t.text :violation
      t.text :circumstances
      t.text :other_people_involved
      t.text :team_members_present
      t.timestamps
    end
  end
end
