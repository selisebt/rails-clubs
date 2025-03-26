class AddTitleToAnnouncements < ActiveRecord::Migration[8.0]
  def change
    add_column :announcements, :title, :string
  end
end
