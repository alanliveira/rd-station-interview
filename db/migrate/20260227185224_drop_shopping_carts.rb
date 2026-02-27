class DropShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    drop_table :shopping_carts
  end
end
