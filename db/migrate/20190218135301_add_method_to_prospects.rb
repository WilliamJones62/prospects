class AddMethodToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :method, :string
  end
end
