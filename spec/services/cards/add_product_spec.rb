require 'rails_helper'

RSpec.describe Carts::AddProductService, type: :service do
  context '.call' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    # let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the cart does not exist' do
      subject { Carts::AddProductService.call(cart: nil, product: product) }

      it { expect(subject[:errors]).to include('Invalid parameters') }
      it { expect(subject[:status]).to eq(:error) }
    end

    context 'when the product does not exist' do
      subject { Carts::AddProductService.call(cart: cart, product: nil) }

      it { expect(subject[:errors]).to include('Invalid parameters') }
      it { expect(subject[:status]).to eq(:error) }
    end

    context 'when the product does not exist' do
      subject { Carts::AddProductService.call(cart: cart, product: product, quantity: nil) }

      it { expect(subject[:errors]).to include('Invalid parameters') }
      it { expect(subject[:status]).to eq(:error) }
    end

    context 'when the add product to cart' do
      subject { Carts::AddProductService.call(cart: cart, product: product, quantity: 1) }

      it { expect(subject[:status]).to eq(:ok) }
      it { expect(subject[:cart]).to be_kind_of(Cart) }
      it { expect { subject }.to change(CartItem, :count).by(1) }
    end
  end
end
