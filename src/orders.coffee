log = require('debug')('log')
_ = require "lodash"

Rest = require "./rest"

Auth = require './auth'
config = require './config'

Orders = {}

### @get_order - Fetch one order API Call ###
# order_id: order id
Orders.get_order = (order_id, callback) ->
  Auth.get_token ->
    Rest._get "/orders/#{order_id}", config.session.access_token, callback

### @ready_to_ship - ###
Orders.ready_to_ship = (seller_id, callback) ->
  Auth.get_token ->
    data =
      "access_token": config.session.access_token
      "seller": seller_id
      "shipping.status": "ready_to_ship"
      "shipping.substatus": "ready_to_print"
      #"shipping.services": "all"
    console.log data
    Orders.recent data, callback


### @recent ###
Orders.recent = (data, callback) ->   
  Rest._get "/orders/search/recent", data, (response) ->
    console.log "TOTAL: #{response.paging.total}"
    callback response.results


### @orders - Orders Search API Call ###
# data: params to filter
Orders.orders = (data, callback) ->   
  Rest._get "/orders/search", data, (response) ->
    log response
    callback response.results

### @touch_orders - Orders Search API Call ###
# data: params to filter
Orders.touch_orders = (data, callback) ->
  _data = _.extend {}, data #, {limit: 1}
  Rest._get "/orders/search", _data, (response) ->
    log response
    callback response.paging.total

### @search_orders - Orders Search API Call ###
# seller: seller id
# offset: integer defaults to 0
# limit: integer default to 50
Orders.search_orders = (seller, filter, callback) ->
  Auth.get_token ->
    data =
      access_token: config.session.access_token
      seller: seller
    data = _.extend data, filter
    _paginate Rest._get, "/orders/search", data, callback

### @pending_orders - Orders Search API Call ###
# seller: seller id
# offset: integer defaults to 0
# limit: integer default to 50
Orders.pending_orders = (seller, offset, callback) ->
  Auth.get_token ->
    data =
      access_token: config.session.access_token
      seller: seller
      offset: offset || 0
    Rest._get "/orders/search/pending", data, callback

### @archived_orders - Orders Search API Call ###
# seller: seller id
# offset: integer defaults to 0
# limit: integer default to 50
Orders.archived_orders = (seller, offset, callback) ->
  Auth.get_token ->
    data =
      access_token: config.session.access_token
      seller: seller
      offset: offset || 0
    Rest._get "/orders/search/archived", data, callback

module.exports = Orders