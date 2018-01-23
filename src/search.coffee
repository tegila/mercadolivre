log = require('debug')('log')
_ = require "lodash"

Rest = require "./rest"

Search = {}

### @single only one result - ###
Search.single = (query_string, callback) ->
  data =
    q: query_string
    limit: 1
  Rest._get "/sites/MLB/search", data, callback 

### @by_query - ###
Search.by_query = (query_string, offset, callback) ->
  data =
    q: query_string
    offset: offset
  Rest._get "/sites/MLB/search", data, callback

### @by_url - ###
Search.by_url = (query_string, callback) ->
  data =
    q: query_string
  Rest._get "/sites/MLB/searchUrl", data, callback

### @items_from_seller - ###
Search.items_from_seller = (seller_id, offset, callback) ->
  data =
    seller_id: seller_id
    offset: offset
  Rest._get "/sites/MLB/search", data, callback

### @items_from_seller_by_category - ###
Search.items_from_seller_by_category = (seller_id, category_id, callback) ->
  data =
    seller_id: seller_id
    category: category_id
  Rest._get "/sites/MLB/search", data, callback

### @items_from_nickname - ###
Search.items_from_nickname = (nickname, callback) ->
  data =
    nickname: nickname
  Rest._get "/sites/MLB/search", data, callback

module.exports = Search