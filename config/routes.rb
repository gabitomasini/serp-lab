Rails.application.routes.draw do
  root "playground#index"

  get "playground", to: "playground#index", as: :playground
  post "playground", to: "playground#create"

  resources :requests, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check
end
