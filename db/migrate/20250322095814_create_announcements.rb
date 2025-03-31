class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :message, null: false
      t.integer :priority, default: 0
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
