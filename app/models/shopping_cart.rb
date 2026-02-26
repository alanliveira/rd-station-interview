class ShoppingCart < ApplicationRecord
  enum :status, { pending: 'pending', abandoned: 'abandoned' }

  def mark_as_abandoned
    abandoned!
  end

  def remove_if_abandoned
    return unless abandoned? && last_interaction_at.present? && last_interaction_at <= 7.days.ago

    destroy!
  end
end
