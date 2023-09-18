class ProfilesController < ApplicationController

  def coaches
    @coaches = User.where(is_coach: true)
    render json: @coaches
  end
  
  def update
    current_user.assign_attributes(user_params)
    if current_user.save(context: :user_update)
      if params[:user][:image].present?
        current_user.image_url = url_for(current_user.image)
        current_user.save
      end
      render json: { message: 'Profile updated successfully.', user: current_user }, status: :ok
    else
      render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
    end
  end


  def coach
    @coach = User.find(params[:id])
    puts @coach
    render json: @coach
  end

  def purchase_history
    @histories = current_user.purchase_histories
    render json: @histories
  end

  private

  def authenticate_user
    unless current_user
      flash[:alert] = "Merci de vous connecter pour voir votre profil."
      redirect_to new_user_session_path
    end
  end

  def authenticate_current_user
    unless current_user == User.find(params['id'])
      flash[:alert] = "Vous ne pouvez accéder qu'à votre profil."
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:firstname, :description, :image)
  end
end



