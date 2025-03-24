class AddNameToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :name, :string
  end
end
