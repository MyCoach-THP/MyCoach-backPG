class PurchaseHistoriesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @purchase_histories = current_user.purchase_histories
    render json: @purchase_histories.as_json(methods: :training_plan)
  end

  def create
    puts "Received parameters: #{params.inspect}"
    @purchase_history = current_user.purchase_histories.build(purchase_history_params)
    
    if @purchase_history.save
      current_user.cartlist = []
      current_user.save
      render json: @purchase_history, status: :created
    else
      render json: @purchase_history.errors, status: :unprocessable_entity
    end
  end

  private

  def purchase_history_params
    params.require(:purchase_history).permit(:training_plan_id, :price, :user_id)
  end
end
