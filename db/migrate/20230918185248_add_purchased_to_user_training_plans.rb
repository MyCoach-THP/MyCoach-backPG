class AddPurchasedToUserTrainingPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :user_training_plans, :purchased, :boolean
  end
end
