class AddSubjectToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :subject, :string
  end
end
