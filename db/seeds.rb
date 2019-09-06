# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

workshop = Workshop.create(
  continent: 'Europe',
  country: 'United Kingdom of Great Britain and Northern Ireland',
  city: 'Edinburgh',
  venue_address: 'A Building
  Some Road
  EH1 1AA',
  start_time: '10:00:00',
  end_time: '11:00:00',
  time_zone: 'GMT',
  ticketing_url: 'https://example.com',
  created_at: '2019-09-06 10:31:16.632335',
)

user = User.new.tap do |u|
    u.email = 'test_user@example.com'
    u.password = 'password'
    u.full_name = 'Test User'
    u.biography = 'test bio'
    u.picture_url = 'https://example.com'
    u.run_workshop_explaination = 'hello'
    u.organiser = true 
    u.workshop_id = workshop.id
    u.skip_confirmation!
    u.save!
end