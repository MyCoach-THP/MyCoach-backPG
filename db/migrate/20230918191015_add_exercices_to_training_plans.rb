class AddExercicesToTrainingPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :training_plans, :exercices, :text
  end
end
