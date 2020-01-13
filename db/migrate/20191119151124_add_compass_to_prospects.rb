class AddCompassToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :compass, :boolean
  end
end
