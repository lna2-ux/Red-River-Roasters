class SitePage < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2, maximum: 120 }
  validates :slug, presence: true, uniqueness: true, length: { minimum: 2, maximum: 80 }
  validates :body, presence: true, length: { minimum: 5 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id title slug body created_at updated_at]
  end
end