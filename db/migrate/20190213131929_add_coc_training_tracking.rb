class AddCocTrainingTracking < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :call_downloaded, :boolean, default: :false
    add_column :users, :coc_training_downloaded, :boolean, default: :false
    add_column :users, :coc_training_complete, :boolean, default: :false
  end
end
