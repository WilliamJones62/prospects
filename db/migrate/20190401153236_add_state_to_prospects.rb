class AddStateToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :state, :string
  end
end
