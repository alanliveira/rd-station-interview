module Carts::CreateService
  def self.call(cart_id: nil)
    Cart.find_by(id: cart_id) || Cart.create!
  end
end
