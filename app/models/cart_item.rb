class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates_presence_of :quantity, :cart, :product
  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  before_validation :register_price, on: :create
  before_validation :calculate_price

  after_save :update_cart_total_price
  after_destroy :update_cart_total_price

  private

  def register_price
    self.unit_price = product.price
  end

  def calculate_price
    self.total_price = unit_price * quantity
  end

  def update_cart_total_price
    cart.calculate_total_price
  end
end
