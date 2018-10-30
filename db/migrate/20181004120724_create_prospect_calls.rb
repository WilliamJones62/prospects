class CreateProspectCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :prospect_calls do |t|
      t.integer :prospect_id
      t.string :who
      t.string :outcome
      t.date :call_date

      t.timestamps
    end
  end
end
