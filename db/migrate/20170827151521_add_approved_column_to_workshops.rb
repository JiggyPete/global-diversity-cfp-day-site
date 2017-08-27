class AddApprovedColumnToWorkshops < ActiveRecord::Migration[5.1]
  def change
    add_column :workshops, :approved, :boolean, default: false
  end
end
