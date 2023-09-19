# config/routes.rb

Rails.application.routes.draw do
  
  resources :purchase_histories, only: [:index, :create]
  
  resources :orders, only: [:index] 
  resources :password_resets, only: [:create, :edit, :update], param: :id
  
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  
  get '/member-data', to: 'members#show'

  scope controller: :profiles do
    get 'coaches', action: :coaches
    get 'coaches/:id', action: :coach
  end
  resources :profiles, only: [:update]


  scope controller: :training_plans do
    get 'training_plans_by_coach/:coach_id', action: :training_plans_by_coach
  end

  resources :training_plans do
    collection do
      get :my_training_plans
    end
  end

  scope controller: :cart do
    post 'create_stripe_session', action: :create_stripe_session
  end

  resources :cart, only: [] do
    collection do
      post :add, action: :add_to_cart
      delete :remove, action: :remove_from_cart
      post :purchase, action: :purchase_cart_items
      get :get, action: :get_user_cartlist
    end
  end

  scope controller: :checkout do
    get 'api/payment/status', action: :payment_status
  end
post 'api/seed_database', to: 'seed#seed_database'

end