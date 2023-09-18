class CreateUserTrainingPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :user_training_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :training_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
