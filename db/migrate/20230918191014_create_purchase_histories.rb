class CreatePurchaseHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :training_plan, null: false, foreign_key: true
      t.decimal :price
      t.string :status

      t.timestamps
    end
  end
end
