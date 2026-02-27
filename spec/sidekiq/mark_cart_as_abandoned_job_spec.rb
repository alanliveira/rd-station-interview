require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    context 'when cart is inactive for more than 3 hours' do
      let!(:cart) { create(:cart, last_interaction_at: 4.hours.ago) }

      it 'marks the cart as abandoned' do
        described_class.new.perform(cart.id)

        expect(cart.reload).to be_abandoned
      end
    end

    context 'when cart is abandoned for more than 7 days' do
      let!(:cart) do
        create(
          :cart,
          status: :abandoned,
          last_interaction_at: 8.days.ago
        )
      end

      it 'removes the cart' do
        described_class.new.perform(cart.id)

        expect(Cart.exists?(cart.id)).to be false
      end
    end

    context 'when cart is still active' do
      let!(:cart) do
        create(
          :cart,
          status: :pending,
          last_interaction_at: 30.minutes.ago
        )
      end

      it 're-schedules the job for 1 hour later' do
        expect do
          described_class.new.perform(cart.id)
        end.to change(described_class.jobs, :size).by(1)

        job = described_class.jobs.last

        expect(job['args']).to eq([cart.id])
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
