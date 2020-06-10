class AddShipToToOrderfroms < ActiveRecord::Migration[5.1]
  def change
    add_column :orderfroms, :ship_to, :string
  end
end
