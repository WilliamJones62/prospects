class AddRepToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :rep, :string
  end
end
