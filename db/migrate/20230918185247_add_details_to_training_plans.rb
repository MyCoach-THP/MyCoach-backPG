class AddDetailsToTrainingPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :training_plans, :name, :string
    add_column :training_plans, :description, :text
    add_column :training_plans, :price, :decimal
  end
end
