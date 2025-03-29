class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :description
      t.datetime :from
      t.datetime :to
      t.integer :status
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
