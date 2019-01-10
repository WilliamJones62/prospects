class CreateBilltos < ActiveRecord::Migration[5.1]
  def change
    create_table :billtos do |t|
      t.string :billto_code
      t.string :terms_code

      t.timestamps
    end
  end
end
