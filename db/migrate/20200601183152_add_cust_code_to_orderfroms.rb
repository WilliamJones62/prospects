class AddCustCodeToOrderfroms < ActiveRecord::Migration[5.1]
  def change
    add_column :orderfroms, :cust_code, :string
  end
end
