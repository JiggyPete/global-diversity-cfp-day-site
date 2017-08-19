class CreateWorkshops < ActiveRecord::Migration[5.1]
  def change
    create_table :workshops do |t|
      t.string :continent
      t.string :country
      t.string :city
      t.text :venue_address
      t.string :google_maps_url
      t.time :start_time
      t.time :end_time
      t.string :time_zone
      t.string :ticketing_url
      t.integer :organiser_id
      t.integer :facilitator_id
      t.text :notes

      t.timestamps
    end
  end
end
