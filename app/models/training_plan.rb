class TrainingPlan < ApplicationRecord
  belongs_to :coach, class_name: "User", foreign_key: "coach_id"
  has_many :user_training_plans
  has_many :users, through: :user_training_plans
  has_many :purchase_histories

end
