log = require('debug')('log')

config = require("./config")

Mercadolivre =
  Auth: require './auth' 
  Users: require './users'
  Categories: {}
  Listings: {}
  Locations: {}
  Currencies: {}
  Item: require './item'
  Search: require './search'
  Orders: require './orders'
  Questions: require './questions'
  Feedback: {}
  Metrics: {}
  Shipping: require './shipping'

module.exports = (client_id, client_secret, session) ->
  config.client_id = client_id
  config.client_secret = client_secret
  config.session = session || {}
  log require("./config")
  return Mercadolivre