class AddCfpUrlToCfp < ActiveRecord::Migration[5.1]
  def change
    add_column :cfps, :cfp_url, :string
  end
end
