class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :resource
      t.json :actions, default: []
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
