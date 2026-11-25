class OrdersController < ApplicationController
  before_action :load_provinces, only: %i[new create]

  def index
    @orders = Order.includes(:customer, :province, order_items: :product)
                   .order(created_at: :desc)
  end

  def new
    @cart_items = build_cart_items
    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items before checking out."
      return
    end

    @order = Order.new
    @customer = Customer.new
    @subtotal = @cart_items.sum { |item| item[:line_total] }
    @default_province = @provinces.find { |p| p.abbreviation.to_s.upcase == "MB" } || @provinces.first
    @tax_breakdown = calculate_tax(@subtotal, @default_province)
    @total = (@subtotal + @tax_breakdown[:total_tax]).round(2)
  end

  def create
    @cart_items = build_cart_items
    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @subtotal = @cart_items.sum { |item| item[:line_total] }

    customer_params = params.require(:customer).permit(:full_name, :email, :street_address, :city, :postal_code)
    order_params = params.require(:order).permit(:province_id)

    province = Province.find_by(id: order_params[:province_id]) || @provinces.first
    @tax_breakdown = calculate_tax(@subtotal, province)
    @total = (@subtotal + @tax_breakdown[:total_tax]).round(2)

    ActiveRecord::Base.transaction do
      @customer = Customer.find_or_initialize_by(email: customer_params[:email].to_s.strip.downcase)
      @customer.assign_attributes(
        full_name: customer_params[:full_name],
        email: customer_params[:email].to_s.strip.downcase,
        street_address: customer_params[:street_address],
        city: customer_params[:city],
        postal_code: customer_params[:postal_code],
        province: province
      )
      @customer.save!

      @order = Order.new(
        customer: @customer,
        province: province,
        subtotal: @subtotal,
        gst_rate: @tax_breakdown[:gst_rate],
        pst_rate: @tax_breakdown[:pst_rate],
        hst_rate: @tax_breakdown[:hst_rate],
        gst_amount: @tax_breakdown[:gst_amount],
        pst_amount: @tax_breakdown[:pst_amount],
        hst_amount: @tax_breakdown[:hst_amount],
        tax_total: @tax_breakdown[:total_tax],
        total_amount: @total,
        status: "pending_payment"
      )
      @order.save!

      @cart_items.each do |item|
        OrderItem.create!(
          order: @order,
          product: item[:product],
          product_name: item[:product].name,
          unit_price: item[:product].price,
          quantity: item[:quantity],
          line_total: item[:line_total]
        )
      end
    end

    session[:cart] = {}

    stripe_session = create_stripe_checkout_session(@order)
    redirect_to stripe_session.url, allow_other_host: true
  rescue Stripe::StripeError => e
    redirect_to order_path(@order), alert: "Stripe payment error: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "Please check your checkout details: #{e.record.errors.full_messages.to_sentence}"
    render :new, status: :unprocessable_entity
  end

  def payment_success
    @order = Order.find(params[:id])
    session_id = params[:session_id].to_s

    if session_id.present?
      checkout_session = Stripe::Checkout::Session.retrieve(session_id)

      if checkout_session.payment_status == "paid"
        payment_ref = checkout_session.payment_intent.presence || checkout_session.id
        @order.update!(
          status: "paid",
          stripe_payment_id: payment_ref,
          paid_at: Time.current
        )
        redirect_to order_path(@order), notice: "Payment confirmed! Order ##{@order.id} is now paid."
        return
      end
    end

    redirect_to order_path(@order), alert: "Payment could not be verified yet."
  rescue Stripe::StripeError => e
    redirect_to order_path(@order), alert: "Unable to verify Stripe payment: #{e.message}"
  end

  def payment_cancel
    @order = Order.find(params[:id])
    @order.update!(status: "cancelled") if @order.status == "pending_payment"
    redirect_to order_path(@order), alert: "Stripe checkout was cancelled for Order ##{@order.id}."
  end

  def show
    @order = Order.includes(:customer, :province, order_items: :product).find(params[:id])
  end

  private

  def create_stripe_checkout_session(order)
    amount_cents = (order.total_amount.to_d * 100).round

    Stripe::Checkout::Session.create(
      mode: "payment",
      allowed_payment_method_types: ["card"],
      customer_email: order.customer&.email,
      client_reference_id: order.id.to_s,
      line_items: [
        {
          price_data: {
            currency: "cad",
            unit_amount: amount_cents,
            product_data: {
              name: "Red River Roasters — Order ##{order.id}"
            }
          },
          quantity: 1
        }
      ],
      metadata: {
        order_id: order.id
      },
      success_url: "#{payment_success_order_url(order)}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: payment_cancel_order_url(order)
    )
  end

  def load_provinces
    @provinces = Province.order(:name)
  end

  def build_cart_items
    cart = session[:cart] || {}
    cart.filter_map do |product_id, qty|
      product = Product.find_by(id: product_id)
      quantity = qty.to_i
      next unless product && quantity > 0

      {
        product: product,
        quantity: quantity,
        line_total: (product.price.to_d * quantity).round(2)
      }
    end
  end

  def calculate_tax(subtotal, province)
    gst_rate = province&.try(:gst_rate).to_d
    pst_rate = province&.try(:pst_rate).to_d
    hst_rate = province&.try(:hst_rate).to_d

    gst_amount = (subtotal * gst_rate).round(2)
    pst_amount = (subtotal * pst_rate).round(2)
    hst_amount = (subtotal * hst_rate).round(2)
    total_tax  = (gst_amount + pst_amount + hst_amount).round(2)

    {
      gst_rate: gst_rate,
      pst_rate: pst_rate,
      hst_rate: hst_rate,
      gst_amount: gst_amount,
      pst_amount: pst_amount,
      hst_amount: hst_amount,
      total_tax: total_tax
    }
  end
end