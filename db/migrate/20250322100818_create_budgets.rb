class CreateBudgets < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.float :total
      t.json :transactions, default: []
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
