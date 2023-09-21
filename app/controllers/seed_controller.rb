# app/controllers/seed_controller.rb
class SeedController < ApplicationController
  def seed_database
    Rails.application.load_seed
    render json: { message: 'Base de donnée mise à jour avec succes' }
  end
end
