class RemoveSubjectFromProspects < ActiveRecord::Migration[5.1]
  def change
    remove_column :prospects, :subject, :string
  end
end
