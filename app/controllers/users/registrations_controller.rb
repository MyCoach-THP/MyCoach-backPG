# app/controllers/users/registrations_controller.rb

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params 
    params.require(:user).permit(:email, :password, :password_confirmation, :is_coach, :image, :description, :firstname)
  end

  def respond_with(resource, _opts = {})
    if resource.save
      if params[:user][:image].present?
        resource.image_url = resource.image.attachment.url
        resource.save
      end
    end
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: {
      message: 'Signed up sucessfully.',
      user: current_user
    }, status: :ok
  end

  def register_failed
    render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
  end
end