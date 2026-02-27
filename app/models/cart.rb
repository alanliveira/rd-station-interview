class Cart < ApplicationRecord
  has_many :cart_items

  enum :status, { pending: 'pending', abandoned: 'abandoned' }

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  after_create_commit do
    MarkCartAsAbandonedJob.perform_in(1.hour, id)
  end

  def calculate_total_price
    self.total_price = cart_items.sum(:total_price).to_f
    save!
  end

  def mark_as_abandoned
    abandoned!
  end

  def remove_if_abandoned
    return unless abandoned? && last_interaction_at.present? && last_interaction_at <= 7.days.ago

    destroy!
  end
end
