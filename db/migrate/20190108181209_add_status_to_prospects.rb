class AddStatusToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :status, :boolean
  end
end
