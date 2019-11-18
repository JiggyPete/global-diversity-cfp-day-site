class AddCocTrainingTypeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :coc_training_type, :string, default: nil
  end
end
