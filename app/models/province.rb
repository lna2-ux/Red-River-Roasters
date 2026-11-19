class Province < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 80 }
  validates :abbreviation, presence: true, uniqueness: true, length: { is: 2 }
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name abbreviation gst_rate pst_rate hst_rate created_at updated_at]
  end
end