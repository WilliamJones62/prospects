class AddZipToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :zip, :string
  end
end
