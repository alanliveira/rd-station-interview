class CreateShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_carts do |t|
      t.string :status, default: 'pending'
      t.datetime :last_interaction_at

      t.timestamps
    end
  end
end
