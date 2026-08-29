Rails.application.routes.draw do
  devise_for :users

  resources :books, only: [:index, :show]

  post "books/:book_id/borrow", to: "loans#create", as: :borrow_book
  patch "loans/:id/return", to: "loans#update", as: :return_loan

  namespace :admin do
    resources :books, only: [:new, :create]
    resources :loans, only: [:index]
  end

  root to: redirect("/books")

  get "up" => "rails/health#show", as: :rails_health_check
end
