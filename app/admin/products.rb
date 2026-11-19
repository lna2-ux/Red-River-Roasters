ActiveAdmin.register Product do
  menu priority: 2
  permit_params :name, :sku, :description, :price, :stock_quantity, :is_active, :on_sale, category_ids: []

  scope :all, default: true
  scope :active
  scope :on_sale
  scope("Low Stock (< 10)") { |products| products.where("stock_quantity < ?", 10) }

  filter :name
  filter :sku
  filter :categories
  filter :price
  filter :stock_quantity
  filter :on_sale
  filter :is_active
  filter :updated_at

  index do
    selectable_column
    id_column
    column :sku
    column :name
    column("Price", sortable: :price) { |product| number_to_currency(product.price) }
    column("Stock", sortable: :stock_quantity) do |product|
      if product.stock_quantity < 10
        status_tag "#{product.stock_quantity} low", class: "warning"
      else
        product.stock_quantity
      end
    end
    column("On Sale") { |product| status_tag product.on_sale? }
    column("Active") { |product| status_tag product.is_active? }
    column("Categories") do |product|
      product.categories.map(&:name).join(", ")
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :sku
      row :name
      row("Price") { |product| number_to_currency(product.price) }
      row :stock_quantity
      row("On Sale") { |product| status_tag product.on_sale? }
      row("Active") { |product| status_tag product.is_active? }
      row("Categories") { |product| product.categories.map(&:name).join(", ") }
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Product Information" do
      f.input :name, placeholder: "e.g., Ethiopia Yirgacheffe Single Origin"
      f.input :sku, placeholder: "e.g., RRR-0106"
      f.input :description
    end

    f.inputs "Pricing, Inventory & Visibility" do
      f.input :price, min: 0, step: 0.01
      f.input :stock_quantity, min: 0
      f.input :on_sale
      f.input :is_active
    end

    f.inputs "Category Assignment" do
      f.input :categories, as: :check_boxes, collection: Category.order(:name)
    end
    f.actions
  end
end