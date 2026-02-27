class Carts::AddItemService
  def self.call(cart: nil, product: nil, quantity: nil)
    return { status: :error, errors: ['Invalid parameters'] } if cart.blank? || product.blank? || quantity.blank?

    item = CartItem.find_by(cart: cart, product: product)
    return { status: :info, message: 'Product not in cart' } unless item.present?

    item.quantity += quantity
    item.save

    { status: :ok, cart: cart }
  end
end
