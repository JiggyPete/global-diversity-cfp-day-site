class CreateCfps < ActiveRecord::Migration[5.1]
  def change
    create_table :cfps do |t|
      t.string :conference_name
      t.string :website
      t.string :twitter_handle
      t.date :cfp_open_date
      t.date :cfp_close_date
      t.date :event_start_date
      t.date :event_end_date

      t.string :continent
      t.string :country
      t.string :city

      t.boolean :code_of_conduct
      t.boolean :free_childcare
      t.text :free_childcare_notes

      t.boolean :financial_support_for_speakers
      t.text :financial_support_for_speakers_notes

      t.boolean :payment_for_speakers
      t.text :payment_for_speakers_notes
    end
  end
end
