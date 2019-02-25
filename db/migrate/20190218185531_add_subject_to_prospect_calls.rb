class AddSubjectToProspectCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :prospect_calls, :subject, :string
  end
end
