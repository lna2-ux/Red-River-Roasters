class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :products, through: :categorizations

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 80 }
  validates :description, presence: true, length: { minimum: 5 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name description created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categorizations products]
  end
end