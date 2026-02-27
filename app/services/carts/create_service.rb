module Carts::CreateService
  def self.call(cart_id: nil)
    cart = Cart.find_by(id: cart_id) || Cart.create!

    cart.shopping_cart = ShoppingCart.create if cart.shopping_cart.blank?
    cart.save!

    cart
  end
end
