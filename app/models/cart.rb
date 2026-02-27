class Cart < ApplicationRecord
  has_one :shopping_cart
  has_many :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

  def calculate_total_price
    self.total_price = cart_items.sum(:total_price).to_f
    save!
  end
end
