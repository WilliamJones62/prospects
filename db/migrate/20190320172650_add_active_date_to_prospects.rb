class AddActiveDateToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :active_date, :date
  end
end
