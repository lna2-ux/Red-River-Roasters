class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :load_nav_categories
  before_action :track_recent_views
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = %i[username street_address city postal_code province_id]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  def load_nav_categories
    @nav_categories = Category.order(:name)
  end

  def track_recent_views
    session[:recently_viewed] ||= []
  end
end