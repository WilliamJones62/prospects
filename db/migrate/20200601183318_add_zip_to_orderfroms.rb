class AddZipToOrderfroms < ActiveRecord::Migration[5.1]
  def change
    add_column :orderfroms, :zip, :string
  end
end
