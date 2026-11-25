class AddStripePaymentToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :stripe_payment_id, :string
    add_column :orders, :paid_at, :datetime
    add_index  :orders, :stripe_payment_id
  end
end