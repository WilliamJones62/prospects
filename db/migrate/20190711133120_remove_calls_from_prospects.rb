class RemoveCallsFromProspects < ActiveRecord::Migration[5.1]
  def change
    remove_column :prospects, :calls, :integer
  end
end
