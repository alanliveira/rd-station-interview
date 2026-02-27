require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  let(:cart) { Cart.create!(total_price: 10) }

  describe '#perform' do
    context 'when cart is inactive for more than 3 hours' do
      let!(:shopping_cart) { create(:shopping_cart, cart: cart, last_interaction_at: 4.hours.ago) }

      it 'marks the cart as abandoned' do
        described_class.new.perform(shopping_cart.id)

        expect(shopping_cart.reload).to be_abandoned
      end
    end

    context 'when cart is abandoned for more than 7 days' do
      let!(:shopping_cart) do
        ShoppingCart.create!(
          cart: cart,
          status: :abandoned,
          last_interaction_at: 8.days.ago
        )
      end

      it 'removes the cart' do
        described_class.new.perform(shopping_cart.id)

        expect(ShoppingCart.exists?(shopping_cart.id)).to be false
      end
    end

    context 'when cart is still active' do
      let!(:shopping_cart) do
        ShoppingCart.create!(
          cart: cart,
          status: :pending,
          last_interaction_at: 30.minutes.ago
        )
      end

      it 're-schedules the job for 1 hour later' do
        expect do
          described_class.new.perform(shopping_cart.id)
        end.to change(described_class.jobs, :size).by(1)

        job = described_class.jobs.last

        expect(job['args']).to eq([shopping_cart.id])
      end
    end

    context 'when cart does not exist' do
      it 'does nothing' do
        expect do
          described_class.new.perform(999999)
        end.not_to change(described_class.jobs, :size)
      end
    end
  end
end
