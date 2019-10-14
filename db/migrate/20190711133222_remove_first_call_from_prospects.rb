class RemoveFirstCallFromProspects < ActiveRecord::Migration[5.1]
  def change
    remove_column :prospects, :first_call, :date
  end
end
