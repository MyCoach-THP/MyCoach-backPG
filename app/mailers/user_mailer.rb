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

end