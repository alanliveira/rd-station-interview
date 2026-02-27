class Carts::AddProductService
  def self.call(cart: nil, product: nil, quantity: nil)
    return { status: :error, errors: ['Invalid parameters'] } if cart.blank? || product.blank? || quantity.blank?

    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = quantity
    cart_item.save

    { status: :ok, cart: cart }
  end
end
