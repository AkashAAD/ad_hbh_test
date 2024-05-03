class CreateLibraryItems < ActiveRecord::Migration[7.1]
  def change
    create_table :library_items do |t|
      t.string :name
      t.string :ref_id
      t.string :genre
      t.string :kind
      t.boolean :availability, default: true

      t.timestamps
    end

    add_index :library_items, [:name, :ref_id], unique: true
  end
end
