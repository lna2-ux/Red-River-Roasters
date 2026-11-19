class Product < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  validates :name, presence: true, length: { minimum: 2, maximum: 120 }
  validates :sku, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_active, inclusion: { in: [true, false] }
  validates :on_sale, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :on_sale, -> { where(on_sale: true) }
  scope :newly_added, -> { where("products.created_at >= ?", 3.days.ago) }
  scope :recently_updated, -> {
    where("products.updated_at >= ? AND products.created_at < ?", 3.days.ago, 3.days.ago)
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name sku description price stock_quantity is_active on_sale created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categorizations categories]
  end
end