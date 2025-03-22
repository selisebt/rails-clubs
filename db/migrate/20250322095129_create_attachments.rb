class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true, null: false
      t.string :filename
      t.string :content_type
      t.integer :file_size

      t.timestamps
    end
  end
end
