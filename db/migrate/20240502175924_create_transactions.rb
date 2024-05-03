class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, index: true
      t.references :library_item, index: true
      t.string :status

      t.timestamps
    end
  end
end
