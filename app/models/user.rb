class User < ApplicationRecord
  after_create :send_welcome

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, 
         jwt_revocation_strategy: JwtDenylist
  has_many :training_plans, foreign_key: "coach_id", class_name: "TrainingPlan"
  has_many :clients, through: :training_plans, source: :users
  has_one_attached :image
  has_many :purchase_histories


  serialize :cartlist, Array
  serialize :ordered, Array

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current # Sauvegarder le moment où le token a été envoyé
    save!
  end

  def purchase_plan(training_plan)
    self.user_training_plans.create!(training_plan: training_plan, purchased: true)
  end

  def add_to_cart(training_plan_id)
    self.cartlist ||= []
    self.cartlist << training_plan_id
    self.save
  end

  def clear_cart
    self.cartlist = []
    self.save
  end

  def remove_from_cart(training_plan_id)
    self.cartlist.delete(training_plan_id) if cartlist.include?(training_plan_id)
    if self.cartlist = [nil]
      self.cartlist = []
    end
    self.save
  end

  def get_cart_items
    TrainingPlan.where(id: self.cartlist)
  end

  private

  def send_welcome
    UserMailer.welcome_email(self).deliver_now
  end

  def send_password_change_notification
    UserMailer.password_changed(self).deliver_now
  end


end