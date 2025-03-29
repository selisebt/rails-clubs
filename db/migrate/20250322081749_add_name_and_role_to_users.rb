class AddNameAndRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_reference :users, :role, null: false, foreign_key: true
  end
end
