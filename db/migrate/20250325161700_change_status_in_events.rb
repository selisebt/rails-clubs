class ChangeStatusInEvents < ActiveRecord::Migration[8.0]
  def change
    change_column :events, :status, :integer, null: false, default: 0
  end
end