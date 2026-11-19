class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :load_nav_categories
  before_action :track_recent_views

  private

  def load_nav_categories
    @nav_categories = Category.order(:name)
  end

  def track_recent_views
    session[:recently_viewed] ||= []
  end
end