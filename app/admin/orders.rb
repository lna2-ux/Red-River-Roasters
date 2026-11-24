ActiveAdmin.register Order do
  permit_params :customer_id, :province_id, :subtotal, :gst_rate, :pst_rate, :hst_rate,
                :gst_amount, :pst_amount, :hst_amount, :tax_total, :total_amount, :status

  index do
    selectable_column
    id_column
    column :customer
    column :province
    column :status
    column("Subtotal") { |o| number_to_currency(o.subtotal) }
    column("Tax") { |o| number_to_currency(o.tax_total) }
    column("Total") { |o| number_to_currency(o.total_amount) }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :customer
      row :province
      row :status
      row("Subtotal") { |o| number_to_currency(o.subtotal) }
      row("GST") { |o| "#{number_to_currency(o.gst_amount)} (#{number_to_percentage(o.gst_rate.to_d * 100, precision: 2)})" }
      row("PST") { |o| "#{number_to_currency(o.pst_amount)} (#{number_to_percentage(o.pst_rate.to_d * 100, precision: 2)})" }
      row("HST") { |o| "#{number_to_currency(o.hst_amount)} (#{number_to_percentage(o.hst_rate.to_d * 100, precision: 2)})" }
      row("Tax Total") { |o| number_to_currency(o.tax_total) }
      row("Total Paid") { |o| number_to_currency(o.total_amount) }
      row :created_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product_name
        column("Unit Price") { |item| number_to_currency(item.unit_price) }
        column :quantity
        column("Line Total") { |item| number_to_currency(item.line_total) }
      end
    end
  end
end