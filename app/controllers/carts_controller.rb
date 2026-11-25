class CartsController < ApplicationController
  before_action :ensure_cart

  def show
    @cart_items = session[:cart].filter_map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      qty = quantity.to_i
      next if qty <= 0

      {
        product: product,
        quantity: qty,
        line_total: product.price.to_d * qty
      }
    end

    @subtotal = @cart_items.sum { |item| item[:line_total] }
  end

  def add_item
    product = Product.find_by(id: params[:product_id])
    unless product
      redirect_to products_path, alert: "Product not found."
      return
    end

    qty = params[:quantity].to_i
    qty = 1 if qty < 1

    key = product.id.to_s
    session[:cart][key] = session[:cart][key].to_i + qty

    redirect_back fallback_location: cart_path, notice: "#{product.name} added to cart."
  end

  def update_item
    key = params[:product_id].to_s
    product = Product.find_by(id: key)
    qty = params[:quantity].to_i

    if qty <= 0
      session[:cart].delete(key)
      label = product ? product.name : "Item"
      redirect_to cart_path, notice: "#{label} removed from cart."
    else
      session[:cart][key] = qty
      label = product ? product.name : "Item"
      redirect_to cart_path, notice: "#{label} quantity updated to #{qty}."
    end
  end

  def remove_item
    key = params[:product_id].to_s
    product = Product.find_by(id: key)
    session[:cart].delete(key)

    label = product ? product.name : "Item"
    redirect_to cart_path, notice: "#{label} removed from cart."
  end

  private

  def ensure_cart
    session[:cart] = {} unless session[:cart].is_a?(Hash)
  end
end