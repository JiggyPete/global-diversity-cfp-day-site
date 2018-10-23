class AddYearToWorkshops < ActiveRecord::Migration[5.1]
  def change
    add_column :workshops, :year, :integer, default: nil
  end
end
