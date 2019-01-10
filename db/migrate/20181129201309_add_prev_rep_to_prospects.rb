class AddPrevRepToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :prev_rep, :string
  end
end
