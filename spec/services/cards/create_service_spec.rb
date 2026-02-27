require 'rails_helper'

RSpec.describe Carts::CreateService, type: :service do
  context '.call' do
    describe 'when the cart does not exist' do
      subject { Carts::CreateService.call(cart_id: nil) }

      it { expect(subject.id).to be_present }
      it { expect(subject.shopping_cart.id).to be_present }
      it { expect(subject.cart_items.count).to eq(0) }
    end

    describe 'when the cart exists' do
      let!(:cart) { create(:cart, :with_shopping_cart) }
      subject { Carts::CreateService.call(cart_id: cart.id) }

      it { expect(subject).to be_kind_of(Cart) }
      it { expect(subject.shopping_cart).to be_kind_of(ShoppingCart) }
      it { expect(subject.id).to eq(cart.id) }
    end
  end
end
