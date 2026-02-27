require 'rails_helper'

RSpec.describe Carts::RemoveProductService, type: :service do
  context '.call' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the cart does not exist' do
      subject { Carts::RemoveProductService.call(cart: nil, product: product) }

      it { expect(subject[:status]).to eq(:error) }
      it { expect(subject[:errors]).to include('Invalid parameters') }
    end

    context 'when the product does not exist' do
      subject { Carts::RemoveProductService.call(cart: cart, product: nil) }

      it { expect(subject[:status]).to eq(:error) }
      it { expect(subject[:errors]).to include('Invalid parameters') }
    end

    context 'when the product is not in the cart' do
      let(:new_product) { create(:product, name: "New Product test", price: 20.0) }

      subject { Carts::RemoveProductService.call(cart: cart, product: new_product) }

      it { expect(subject[:status]).to eq(:info) }
      it { expect(subject[:message]).to include('Product not in cart') }
    end

    context 'when the remove item from cart' do
      subject { Carts::RemoveProductService.call(cart: cart, product: product) }

      it { expect(subject[:status]).to eq(:ok) }
      it { expect(subject[:cart]).to be_kind_of(Cart) }
      it { expect { subject }.to change(CartItem, :count).by(-1) }
    end
  end
end
