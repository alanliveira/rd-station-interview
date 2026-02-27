class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(shopping_cart_id)
    shopping_cart = ShoppingCart.find_by(id: shopping_cart_id)
    return unless shopping_cart

    shopping_cart.mark_as_abandoned if shopping_cart.last_interaction_at < 3.hours.ago

    if shopping_cart.abandoned?
      shopping_cart.remove_if_abandoned
      return
    end

    # reprograma o job para rodar novamente em 1 hora
    self.class.perform_in(1.hour, shopping_cart.id)
  end
end
