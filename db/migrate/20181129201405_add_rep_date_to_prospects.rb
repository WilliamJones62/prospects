class AddRepDateToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :rep_date, :date
  end
end
