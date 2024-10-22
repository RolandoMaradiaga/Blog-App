Rails.application.routes.draw do
  devise_for :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  # Ensure resourceful routes for users
  resources :users, only: [:show, :edit, :update]

  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  get "home/index"
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create, :update, :destroy]
      # If you plan to implement comments, you could add:
      # resources :posts do
      #   resources :comments, only: [:index, :create]
      # end
    end
  end

  # Additional routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
