Rails.application.routes.draw do
  resources :comments, only: :index
  resources :users, only: :index
end
