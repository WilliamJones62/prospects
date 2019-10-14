class AddSourceToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :source, :string
  end
end
