Rails.application.routes.draw do
  devise_for :users

  # Página pública
  root "home#index"

  # Páginas privadas
  get "dashboard", to: "dashboard#index"
  get "settings", to: "settings#index", as: :settings

  # CRUD de livros
  resources :books do
    member do
      patch :borrow
      patch :return   # <= precisa estar aqui
    end

    collection do
      get :borrowed
    end
  end


  # Empréstimos
  resources :loans do
    collection do
      get :my_loans   # /loans/my_loans -> usuário vê seus empréstimos
    end
  end
end
