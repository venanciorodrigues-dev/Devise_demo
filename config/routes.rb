Rails.application.routes.draw do
  get "dashboard/index"
  get "home/index"
  devise_for :users

  # Página pública
  root "home#index"

  # Página privada
  get "dashboard", to: "dashboard#index"
end
