class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :plan_name
      t.integer :books_limit, default: 0
      t.integer :magazines_limit, default: 0

      t.timestamps
    end
  end
end
