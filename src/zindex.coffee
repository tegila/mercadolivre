Mercadolivre =
  Auth: Auth 
  Users: Users
  Categories: {}
  Listings: {}
  Locations: {}
  Currencies: {}
  Item: Item
  Search: Search
  Orders: Orders
  Questions: Questions
  Feedback: {}
  Metrics: {}
  Shipping: Shipping

Mercadolivre.init = (client_id, client_secret, session) ->
  config.client_id = client_id
  config.client_secret = client_secret
  config.session = session || {}
  return Mercadolivre

module.exports = Mercadolivre.init