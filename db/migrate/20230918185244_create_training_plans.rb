class CreateTrainingPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :training_plans do |t|
      t.string :url

      t.timestamps
    end
  end
end
