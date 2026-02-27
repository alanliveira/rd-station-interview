require 'rails_helper'

RSpec.describe Carts::AddItemService, type: :service do
  context '.call' do
    let!(:cart) { create(:cart, :with_shopping_cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the cart does not exist' do
      subject { Carts::AddItemService.call(cart: nil, product: product, quantity: 1) }

      it { expect(subject[:errors]).to include('Invalid parameters') }
      it { expect(subject[:status]).to eq(:error) }
    end

    context 'when the product does not exist' do
      subject { Carts::AddItemService.call(cart: cart, product: nil, quantity: 1) }

      it { expect(subject[:errors]).to include('Invalid parameters') }
      it { expect(subject[:status]).to eq(:error) }
    end

    context 'when the quantity does not exist' do
      subject { Carts::AddItemService.call(cart: cart, product: product, quantity: nil) }

      it { expect(subject[:errors]).to include('Invalid parameters') }
      it { expect(subject[:status]).to eq(:error) }
    end

    context 'when the product is not in the cart' do
      let(:new_product) { create(:product, name: "New Product test", price: 20.0) }

      subject { Carts::AddItemService.call(cart: cart, product: new_product, quantity: 1) }

      it { expect(subject[:status]).to eq(:info) }
      it { expect(subject[:message]).to eq('Product not in cart') }
    end

    context 'when the add item to cart' do
      subject { Carts::AddItemService.call(cart: cart, product: product, quantity: 1) }

      it { expect(subject[:status]).to eq(:ok) }
      it { expect(subject[:cart]).to be_kind_of(Cart) }
      it { expect { subject }.to change { cart_item.reload.quantity }.from(1).to(2) }
    end
  end
end
