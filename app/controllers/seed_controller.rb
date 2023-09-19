# app/controllers/seed_controller.rb
class SeedController < ApplicationController
  def seed_database
    Rails.application.load_seed
    render json: { message: 'Database seeded successfully' }
  end
end
