class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(cart_id)
    cart = Cart.find_by(id: cart_id)
    return unless cart

    cart.mark_as_abandoned if cart.last_interaction_at < 3.hours.ago

    if cart.abandoned?
      cart.remove_if_abandoned
      return
    end

    # reprograma o job para rodar novamente em 1 hora
    self.class.perform_in(1.hour, cart.id)
  end
end
