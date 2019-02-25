class RemoveMethodFromProspects < ActiveRecord::Migration[5.1]
  def change
    remove_column :prospects, :method, :string
  end
end
