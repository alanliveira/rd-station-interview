class Carts::RemoveProductService
  def self.call(cart: nil, product: nil)
    return { status: :error, errors: ['Invalid parameters'] } if cart.blank? || product.blank?

    item = CartItem.find_by(cart: cart, product: product)
    return { status: :info, message: 'Product not in cart' } unless item.present?

    return { status: :error, errors: ['Could not remove product'] } unless item.destroy

    cart.calculate_total_price

    { status: :ok, cart: cart }
  end
end
