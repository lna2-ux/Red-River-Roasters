class CategoriesController < ApplicationController
  # 2.2 Dedicated navigation by category (separate from keyword search)
  def show
    @category = Category.find(params[:id])
    @products = @category.products.active.order(:name).page(params[:page]).per(12)
  end
end