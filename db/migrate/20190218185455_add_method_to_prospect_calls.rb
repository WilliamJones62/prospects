class AddMethodToProspectCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :prospect_calls, :method, :string
  end
end
