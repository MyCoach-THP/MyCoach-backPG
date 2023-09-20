class UserMailer < ApplicationMailer
  default from: "gregimbeau@gmail.com"

  def welcome_email(user)
    @user = user
    @url = "http://monsite.fr/login"
    mail(to: @user.email, subject: "Bienvenue chez nous !")
  end

  def password_reset(user)
      @user = user
      @url = params[:reset_password_url]
      mail(to: @user.email, subject: 'Réinitialisation de votre mot de passe')
  end

  def notify_coach_of_purchase(coach, client, training_plan)
    @coach = coach
    @client = client
    @training_plan = training_plan
    mail(to: @coach.email, subject: "Un de vos plans d'entraînement a été acheté !")
  end

end