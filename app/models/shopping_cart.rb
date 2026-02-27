class ShoppingCart < ApplicationRecord
  belongs_to :cart

  enum :status, { pending: 'pending', abandoned: 'abandoned' }

  after_create_commit do
    MarkCartAsAbandonedJob.perform_in(1.hour, id)
  end

  def mark_as_abandoned
    abandoned!
  end

  def remove_if_abandoned
    return unless abandoned? && last_interaction_at.present? && last_interaction_at <= 7.days.ago

    destroy!
  end
end
