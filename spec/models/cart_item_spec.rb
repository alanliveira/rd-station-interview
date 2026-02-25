require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context '#create' do
    let!(:cart) { create(:cart, total_price: 0) }
    let!(:product) { create(:product, price: 1_500) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

    it 'when add new product' do
      expect(cart_item.total_price).to eq(3_000)
      expect(cart_item.cart.total_price).to eq(3_000)
    end

    it 'when add second product' do
      product2 = create(:product, price: 2_500)
      cart_item2 = create(:cart_item, cart: cart, product: product2, quantity: 2)

      expect(cart_item2.total_price).to eq(5_000)
      expect(cart_item2.cart.total_price).to eq(8_000)
    end

    it 'when update quantity' do
      cart_item.update(quantity: 3)

      expect(cart_item.total_price).to eq(4_500)
      expect(cart_item.cart.total_price).to eq(4_500)
    end

    it 'when update quantity to zero' do
      cart_item.update(quantity: 0)

      expect(cart_item.total_price).to eq(0)
      expect(cart_item.cart.total_price).to eq(0)
    end
  end
end
