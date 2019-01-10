class RemoveMngrFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :mngr, :string
  end
end
