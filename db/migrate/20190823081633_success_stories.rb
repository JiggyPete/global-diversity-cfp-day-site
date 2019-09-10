class SuccessStories < ActiveRecord::Migration[5.1]
  def change
    create_table :success_stories do |t|
      t.string :full_name
      t.string :twitter
      t.string :profile_picture_url
      t.string :email_address
      t.string :talk_title
      t.string :event_name
      t.string :events_twitter
      t.date :event_start_date
      t.date :event_end_date
      t.boolean :premission_for_public_use, default: false
      t.boolean :approved, default: false
    end
  end
end


