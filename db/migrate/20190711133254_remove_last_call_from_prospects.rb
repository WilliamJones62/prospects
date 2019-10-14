class RemoveLastCallFromProspects < ActiveRecord::Migration[5.1]
  def change
    remove_column :prospects, :last_call, :date
  end
end
