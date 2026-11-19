ActiveAdmin.register Category do
  menu priority: 3
  permit_params :name, :description

  filter :name
  filter :description
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column("Description") { |cat| truncate(cat.description, length: 90) }
    column("Products Count") { |cat| cat.products.count }
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Assigned Products (#{category.products.count})" do
      table_for category.products.order(:name) do
        column :sku
        column("Name") { |p| link_to p.name, admin_product_path(p) }
        column("Price") { |p| number_to_currency(p.price) }
        column :stock_quantity
        column("Active") { |p| status_tag p.is_active? }
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Category Details" do
      f.input :name
      f.input :description
    end
    f.actions
  end
end