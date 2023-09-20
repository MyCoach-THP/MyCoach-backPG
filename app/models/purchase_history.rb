class PurchaseHistory < ApplicationRecord
  belongs_to :user
  belongs_to :training_plan

  after_create :notify_coach

  private

  def notify_coach
    coach = self.training_plan.coach
    UserMailer.notify_coach_of_purchase(coach, self.user, self.training_plan).deliver_now
  end

end
