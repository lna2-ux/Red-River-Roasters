class Customer < ApplicationRecord
  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  validates :full_name, :email, presence: true
end