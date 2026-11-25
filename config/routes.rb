Rails.application.routes.draw do
  devise_for :accounts
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "products#index"

  resources :products, only: %i[index show]
  resources :categories, only: %i[show]

  get    "/cart",             to: "carts#show",        as: :cart
  post   "/cart/add_item",    to: "carts#add_item",    as: :add_cart_item
  patch  "/cart/update_item", to: "carts#update_item", as: :update_cart_item
  delete "/cart/remove_item", to: "carts#remove_item", as: :remove_cart_item

  resources :orders, only: %i[index new create show] do
    member do
      get :payment_success
      get :payment_cancel
    end
  end

  get "/about",   to: "site_pages#show", defaults: { slug: "about" },   as: :about
  get "/contact", to: "site_pages#show", defaults: { slug: "contact" }, as: :contact
end