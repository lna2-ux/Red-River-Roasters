# frozen_string_literal: true

require "ostruct"

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: "Red River Roasters — Store Operations" do
    columns do
      column do
        panel "Catalog Overview" do
          attributes_table_for OpenStruct.new(
            total_products: Product.count,
            active_products: Product.active.count,
            on_sale_products: Product.on_sale.count,
            total_categories: Category.count,
            total_stock_units: Product.sum(:stock_quantity)
          ) do
            row("Total Products") { |s| status_tag s.total_products, class: "yes" }
            row("Active Storefront Items") { |s| s.active_products }
            row("Currently On Sale") { |s| status_tag s.on_sale_products, class: "warning" }
            row("Product Categories") { |s| s.total_categories }
            row("Total Inventory Units") { |s| number_with_delimiter(s.total_stock_units) }
          end
        end
      end

      column do
        panel "Quick Store Actions" do
          ul do
            li link_to("Add New Product", new_admin_product_path)
            li link_to("Manage All Products", admin_products_path)
            li link_to("Add New Category", new_admin_category_path)
            li link_to("Manage Categories", admin_categories_path)
            li link_to("Open Public Storefront", root_path, target: "_blank", rel: "noopener")
          end
        end

        panel "Products by Category" do
          table_for Category.order(:name) do
            column("Category") { |cat| link_to cat.name, admin_category_path(cat) }
            column("Assigned Products") { |cat| cat.products.count }
          end
        end
      end
    end

    panel "Recently Updated Products" do
      table_for Product.order(updated_at: :desc).limit(8) do
        column :sku
        column("Product") { |p| link_to p.name, admin_product_path(p) }
        column("Price") { |p| number_to_currency(p.price) }
        column :stock_quantity
        column("On Sale") { |p| status_tag p.on_sale? }
        column("Active") { |p| status_tag p.is_active? }
        column :updated_at
      end
    end
  end
end