log = require('debug')('log')
_ = require "lodash"

Rest = require "./rest"

Auth = require './auth'
config = require './config'

Shipping = {}

### @get_order - Fetch one order API Call ###
# order_id: order id
Shipping.get_shipment = (shipping_id, callback) ->
  Auth.get_token ->
    Rest._get "/shipments/#{shipping_id}", config.session, callback

module.exports = Shipping