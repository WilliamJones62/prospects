class CreateOrderfroms < ActiveRecord::Migration[5.1]
  def change
    create_table :orderfroms do |t|
      t.string :bus_name
      t.string :acct_manager

      t.timestamps
    end
  end
end
