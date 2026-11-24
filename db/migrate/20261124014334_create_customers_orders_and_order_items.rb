class CreateCustomersOrdersAndOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :customers_orders_and_order_items do |t|
      t.timestamps
    end
  end
end
