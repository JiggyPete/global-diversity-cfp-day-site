class AddAlternativeDateToWorkshops < ActiveRecord::Migration[5.1]
  def change
    add_column :workshops, :alternative_date, :string
  end
end
