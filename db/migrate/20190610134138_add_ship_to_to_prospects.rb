class AddShipToToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :ship_to, :string
  end
end
