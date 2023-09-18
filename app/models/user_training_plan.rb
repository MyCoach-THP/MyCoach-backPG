class UserTrainingPlan < ApplicationRecord
  belongs_to :user
  belongs_to :training_plan

  attribute :purchased, :boolean, default: false
end
