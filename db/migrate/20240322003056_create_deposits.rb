class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.integer :amount
      t.string :deposit_date
      t.references :tradeline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
