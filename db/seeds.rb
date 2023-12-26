user = User.create(email: "example@example.com", password: "example@12345" )
keywords = ["Action", "Comedy", "Drama", "Horror"]
user_order = user.user_orders.create(content: keywords.join(', '))
new_keywords = keywords.map {|content| {user_order_id: user_order.id, content: content}}
user_order.keywords.insert_all(new_keywords).map { |result| result['id'] }