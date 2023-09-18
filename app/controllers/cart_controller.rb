# app/controllers/cart_controller.rb
require 'stripe'

class CartController < ApplicationController
  before_action :authenticate_user!
  
  def add_to_cart
    training_plan_id = params[:training_plan_id]
  
    if current_user.cartlist.include?(training_plan_id)
      render json: { error: 'This training plan is already in your cart' }, status: :unprocessable_entity
    else
      current_user.add_to_cart(training_plan_id)
      render json: { message: 'Training plan successfully added to cart' }
    end
  end

  def get_user_cartlist
      cartlist = current_user.cartlist
      render json: { cartlist: cartlist }
  end

  def remove_from_cart
    training_plan_id = params[:training_plan_id]
  
    if current_user.cartlist.include?(training_plan_id)
      current_user.cartlist.delete(training_plan_id)
      current_user.save
      render json: { message: "Suppression de de l'élément du panier OK" }
    else
      render json: { error: "Plan d'entraînement introuvable dans le panier" }, status: :not_found
    end
  end
  
  def purchase_cart_items
    current_user.purchase_cart_items
  end

  def create_stripe_session
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    cart_items = calculate_cart_items(current_user)
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: cart_items,
      mode: 'payment',
      success_url: 'http://localhost:5173/success', 
      cancel_url: 'http://localhost:5173/cancel' 
    )
    render json: { session_id: session.id, payment_success: true } 
  end

  private

  def calculate_cart_items(user)
    cart_items = user.get_cart_items
    cart_items.map do |item|
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: item.name,
          },
          unit_amount: (item.price * 100).to_i,
        },
        quantity: 1,
      }
    end
  end
end