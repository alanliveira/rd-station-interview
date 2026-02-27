class AddColumnCartToShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    add_reference :shopping_carts, :cart, null: false, foreign_key: true
  end
end
