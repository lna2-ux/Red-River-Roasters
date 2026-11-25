publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"].to_s.strip.presence ||
                  Rails.application.credentials.dig(:stripe, :publishable_key)

secret_key      = ENV["STRIPE_SECRET_KEY"].to_s.strip.presence ||
                  Rails.application.credentials.dig(:stripe, :secret_key)

Rails.configuration.stripe = {
  publishable_key: publishable_key,
  secret_key: secret_key
}

Stripe.api_key = secret_key