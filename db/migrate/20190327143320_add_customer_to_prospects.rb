class AddCustomerToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :customer, :boolean
  end
end
