class AddCityToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :city, :string
  end
end
