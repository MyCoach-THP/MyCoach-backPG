class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "Total from params: #{params[:total]}"
    @user = current_user
    @total = params[:total].to_d
    Rails.logger.debug "Total after conversion: #{@total}"
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: (@total * 100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout'
            }
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )
    
    respond_to do |format|
      format.json { render json: { session_id: @session.id } }
    end

  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    @amount = @payment_intent.amount
    
    current_user.cartlist.each do |training_plan_id|
      current_user.purchase_histories.create(
        training_plan_id: training_plan_id,
         price: training_plan.price,
        status: "Paid"
      )
    end

  end

  def cancel
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    @amount = @payment_intent.amount
  end

  def payment_status
    # Find the latest payment history for the user
    last_purchase = current_user.purchase_histories.last
    
    if last_purchase&.status == 'Paid'
      render json: { paymentStatus: 'success' }
    else
      render json: { paymentStatus: 'failure' }
    end
  end

end