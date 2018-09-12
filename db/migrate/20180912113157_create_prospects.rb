class CreateProspects < ActiveRecord::Migration[5.1]
  def change
    create_table :prospects do |t|
      t.string :customer_id
      t.string :name
      t.integer :calls
      t.date :first_call
      t.date :last_call
      t.string :credit_terms

      t.timestamps
    end
  end
end
