class CartsController < ApplicationController
  before_action :ensure_cart

  def show
    @cart_items = build_cart_items
    @subtotal = @cart_items.sum { |row| row[:line_total] }
  end

  def add_item
    product = Product.active.find(params[:product_id])
    qty = [params[:quantity].to_i, 1].max
    key = product.id.to_s
    session[:cart][key] = (session[:cart][key] || 0) + qty

    flash[:notice] = "Added #{qty} × #{product.name} to your cart."
    redirect_back fallback_location: products_path
  end

  def update_item
    key = params[:product_id].to_s
    qty = params[:quantity].to_i

    if qty <= 0
      session[:cart].delete(key)
      flash[:notice] = "Removed item from your cart."
    else
      session[:cart][key] = qty
      flash[:notice] = "Updated item quantity to #{qty}."
    end

    redirect_to cart_path
  end

  def remove_item
    key = params[:product_id].to_s
    removed = session[:cart].delete(key)

    if removed
      flash[:notice] = "Removed item from your shopping cart."
    else
      flash[:alert] = "Item was not found in your cart."
    end

    redirect_to cart_path
  end

  private

  def ensure_cart
    session[:cart] ||= {}
  end

  def build_cart_items
    session[:cart].filter_map do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product && qty.to_i > 0

      {
        product: product,
        quantity: qty.to_i,
        line_total: (product.price.to_d * qty.to_i).round(2)
      }
    end
  end
end