class CreateGeocodes < ActiveRecord::Migration[5.1]
  def change
    create_table :geocodes do |t|
      t.string :state_name
      t.string :city_name
      t.string :zip

      t.timestamps
    end
  end
end
