class ProductsController < ApplicationController
  def index
    @products = Product.active.includes(:categories)

    # 2.4 Filtering (on_sale, new, recently_updated)
    case params[:filter]
    when "on_sale"
      @products = @products.on_sale
      flash.now[:notice] = "Showing Red River Roasters items currently on sale."
    when "new"
      @products = @products.newly_added
      flash.now[:notice] = "Showing new arrivals added within the last 3 days."
    when "recently_updated"
      @products = @products.recently_updated
      flash.now[:notice] = "Showing recently updated items from the last 3 days."
    end

    # 2.6 Keyword search (in title/name or description) + optional category restriction
    if params[:q].present?
      keyword = "%#{params[:q].strip}%"
      @products = @products.where(
        "products.name LIKE ? OR products.description LIKE ?",
        keyword,
        keyword
      )
    end

    if params[:category_id].present?
      @selected_category = Category.find_by(id: params[:category_id])
      if @selected_category
        @products = @products.joins(:categories).where(categories: { id: @selected_category.id })
      end
    end

    @products = @products.distinct.order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
    @product = Product.active.find(params[:id])
    @primary_category = @product.categories.first

    session[:recently_viewed] = ([ @product.id ] + Array(session[:recently_viewed])).uniq.first(5)
    @recently_viewed_products = Product.active.where(id: session[:recently_viewed] - [ @product.id ])
  end
end