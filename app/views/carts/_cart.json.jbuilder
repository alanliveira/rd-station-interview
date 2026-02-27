json.id cart.id

json.products cart.cart_items do |item|
  json.id item.id
  json.name item.product.name
  json.quantity item.quantity
  json.unit_price item.unit_price.to_f
  json.total_price item.total_price.to_f
end

json.total_price cart.total_price.to_f
