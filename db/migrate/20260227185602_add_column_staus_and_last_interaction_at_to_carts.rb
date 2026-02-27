class AddColumnStausAndLastInteractionAtToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_interaction_at, :datetime
    add_column :carts, :status, :string, default: 'pending'
  end
end
