Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "products#index"

  resources :products, only: %i[index show]
  resources :categories, only: %i[show]
  get "/about", to: "site_pages#show", defaults: { slug: "about" }, as: :about
  get "/contact", to: "site_pages#show", defaults: { slug: "contact" }, as: :contact
end