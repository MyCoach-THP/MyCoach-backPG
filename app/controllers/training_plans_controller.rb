class TrainingPlansController < ApplicationController
  before_action :set_training_plan, only: %i[ show update destroy ]

  # GET /training_plans
  def index
    if current_user && current_user.is_coach?
      @training_plans = TrainingPlan.where(coach_id: current_user.id)
    else
      @training_plans = TrainingPlan.all
    end
    render json: @training_plans
  end


  # GET /training_plans/1
  def show
    training_plans_by_coach = TrainingPlan.where(coach_id: params[:id])

    render json: training_plans_by_coach
  end

  # POST /training_plans
  def create
    @training_plan = current_user.training_plans.new(training_plan_params)

    if @training_plan.save
      render json: @training_plan, status: :created, location: @training_plan
    else
      render json: @training_plan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /training_plans/1
  def update
    if @training_plan.update(training_plan_params)
      render json: @training_plan
    else
      render json: @training_plan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /training_plans/1
  def destroy
    puts "Current User: #{current_user.inspect}"
    puts "Training Plan Coach: #{@training_plan.coach.inspect}"
    
    if @training_plan.coach == current_user  # Assurez-vous que l'utilisateur actuel est le coach
      @training_plan.destroy
      render json: { message: 'Plan éffacé avec succes' }, status: :ok
    else
      render json: { error: 'non autorisé' }, status: :unauthorized
    end
  end


    # GET /my_training_plans
  def my_training_plans
    if current_user # Assurez-vous que l'utilisateur est connecté
      purchased_plans = current_user.user_training_plans.where(purchased: true).map(&:training_plan)
      render json: purchased_plans
    else
      render json: { error: 'Non-autentifié' }, status: :unauthorized
    end
  end

    # GET /training_plans_by_coach/:coach_id
  def training_plans_by_coach
    @training_plans = TrainingPlan.where(coach_id: params[:coach_id])
    render json: @training_plans
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_training_plan
      @training_plan = TrainingPlan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def training_plan_params
      params.require(:training_plan).permit(:url, :name, :description, :price, :coach_id, :exercices)
    end
end
