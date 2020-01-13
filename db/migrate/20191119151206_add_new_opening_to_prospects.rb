class AddNewOpeningToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :new_opening, :boolean
  end
end
