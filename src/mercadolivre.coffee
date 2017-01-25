Rest = require "./rest"
_ = require "lodash"
log = require('debug')('log:meli')

Mercadolivre = (client_id, client_secret, session) ->
  @session = session || {}
  mlAPI = Rest "api.mercadolibre.com"

  ### @_is_it_the_same compare two objects ###
  @_is_it_the_same = (obj1, obj2) ->
    if obj1.date_created is obj2.date_created
      return true
    else
      return false 

  ### @_is_updated_version compare two objects ###
  @_is_updated_version = (obj1, obj2) ->
    if (obj1.last_updated? and obj1.last_updated is obj2.last_updated) or (obj1.date_last_updated? and obj1.date_last_updated is obj2.date_last_updated)
      return true
    else
      return false

  ### @compare two lists and return the result ###
  @compare = (old_list, new_list) ->
    ### @result ###
    result = 
      insert: new Array()
      updated:  new Array()
      #deleted: new Array()

    for i in [0..new_list.length-1]
      for j in [0..old_list.length-1]
        if @_is_it_the_same old_list[j], new_list[i]
          if not @_is_updated_version old_list[j], new_list[i]
            result.updated.push _.extend {}, old_list[j], new_list[i]
          break
        else if j is old_list.length-1
          result.insert.push new_list[i]
    result.all_changes = _.extend {}, result.insert, result.updated
    #result.deleted = _.differenceBy old_list, new_list, @_is_an_updated_version
    return result

  _paginate = (fn, url, params, callback, _yield) ->
    _yield = _yield or []
    defaults = 
      offset: 0
      limit: 50
    params = _.extend {}, defaults, params

    log url, params
    fn url, params, (res) ->
      log res.results[0]
      _yield = _.union _yield, res.results
      params.offset += res.paging.limit

      if res.paging.total > res.paging.offset+res.paging.limit
        #callback _yield
        _paginate fn, url, params, callback, _yield
      else
        callback _yield

  ### @items_from_authenticated_seller - Fetch one order API Call ###
  @items_from_authenticated_seller = (seller, filter, callback) ->
    @get_token ->
      data =
        access_token: @session.token
      data = _.extend {}, filter, data
      _paginate mlAPI._get, "/users/#{seller}/items/search", data, callback

  ### @items_status - Fetch one order API Call ###
  @items_status = (seller, callback) ->
    @get_token ->
      data =
        access_token: @session.token
      data = _.extend data, {status: 'active'}
      _paginate mlAPI._get, "/users/#{seller}/items/search", data, (active) ->
        data = _.extend data, {status: 'paused'}
        _paginate mlAPI._get, "/users/#{seller}/items/search", data, (paused) ->
          data = _.extend data, {status: 'closed'}
          _paginate mlAPI._get, "/users/#{seller}/items/search", data, (closed) ->
            callback 
              active: active
              paused: paused
              closed: closed

  ### @get_user - ###
  @get_user = (user_id, callback) ->
    mlAPI._get "/users/#{user_id}", null, (response) ->
      callback response

  ### @get_item - ###
  @get_item = (item_id, callback) ->
    @get_token =>
      data =
        access_token: @session.token
      mlAPI._get "/items/#{item_id}", data, callback

  ### @get_item_and_description - ###
  @get_item_and_description = (item_id, callback) ->  
    @get_token =>
      data =
        access_token: @session.token
      mlAPI._get "/items/#{item_id}", data, (product) ->
        mlAPI._get "/items/#{item_id}/description", data, (description) ->
          callback _.extend {}, product, description


  @get_item_description = (item_id, callback) ->
    @get_token =>
      data =
        access_token: @session.token
      mlAPI._get "/items/#{item_id}/description", data, callback
      
  ### @save_item - ###
  @save_item = (item, callback) ->
    query =
      access_token: @session.token
    mlAPI._post "/items", query, item, callback


  ### @update_item - ###
  @update_item = (item_id, callback) ->
    data =
      access_token: @session.token
    mlAPI._put "/items/#{item_id}", data, callback

  
  @get_item_own = (item_id, callback) ->
    mlAPI._get "/items/#{item_id}", null, callback

  ### @search only one - ###
  @search_one = (query_string, callback) ->
    data =
      q: query_string
      limit: 1
    mlAPI._get "/sites/MLB/search", data, callback 

  ### @search - ###
  @search = (query_string, offset, callback) ->
    data =
      q: query_string
      offset: offset
    mlAPI._get "/sites/MLB/search", data, callback

  ### @search_url - ###
  @search_url = (query_string, callback) ->
    data =
      q: query_string
    mlAPI._get "/sites/MLB/searchUrl", data, callback
 

  
  ### @items_from_seller - ###
  @search_items_from_seller = (seller_id, offset, callback) ->
    data =
      seller_id: seller_id
      offset: offset
    mlAPI._get "/sites/MLB/search", data, callback

  ### @items_from_seller_by_category - ###
  @search_items_from_seller_by_category = (seller_id, category_id, callback) ->
    data =
      seller_id: seller_id
      category: category_id
    mlAPI._get "/sites/MLB/search", data, callback

  ### @items_from_nickname - ###
  @search_items_from_nickname = (nickname, callback) ->
    data =
      nickname: nickname
    mlAPI._get "/sites/MLB/search", data, callback



  ### @get_order - Fetch one order API Call ###
  # order_id: order id
  @get_order = (order_id, callback) ->
    @get_token ->
      data =
        access_token: @session.token
      mlAPI._get "/orders/#{order_id}", data, callback

  ### @ready_to_ship - ###
  @ready_to_ship = (seller_id, callback) ->
    @get_token ->
      data =
        "access_token": @session.token
        "seller": seller_id
        "shipping.status": "ready_to_ship"
        "shipping.substatus": "ready_to_print"
      @orders data, callback


  ### @orders - Orders Search API Call ###
  # data: params to filter
  @orders = (data, callback) ->   
    mlAPI._get "/orders/search", data, (response) ->
      log response
      callback response.results

  ### @touch_orders - Orders Search API Call ###
  # data: params to filter
  @touch_orders = (data, callback) ->
    _data = _.extend {}, data#, {limit: 1}
    mlAPI._get "/orders/search", _data, (response) ->
      log response
      callback response.paging.total

  ### @search_orders - Orders Search API Call ###
  # seller: seller id
  # offset: integer defaults to 0
  # limit: integer default to 50
  @search_orders = (seller, filter, callback) ->
    @get_token ->
      data =
        access_token: @session.token
        seller: seller
      data = _.extend data, filter
      _paginate mlAPI._get, "/orders/search", data, callback

  ### @pending_orders - Orders Search API Call ###
  # seller: seller id
  # offset: integer defaults to 0
  # limit: integer default to 50
  @pending_orders = (seller, offset, callback) ->
    @get_token ->
      data =
        access_token: @session.token
        seller: seller
        offset: offset || 0
      mlAPI._get "/orders/search/pending", data, callback
  
  ### @archived_orders - Orders Search API Call ###
  # seller: seller id
  # offset: integer defaults to 0
  # limit: integer default to 50
  @archived_orders = (seller, offset, callback) ->
    @get_token ->
      data =
        access_token: @session.token
        seller: seller
        offset: offset || 0
      mlAPI._get "/orders/search/archived", data, callback

  ### @get_token - Ensure always send last valid token ###
  @get_token = (callback) ->
    if @session.token?
      if @session.token.invalid?
        return _refresh_token callback
      callback @session.token
    else
      _init_token callback

  # Get a brand new token from OAUTH2 #
  _init_token = (callback) ->
    data =
      grant_type: "client_credentials"
      client_id: client_id
      client_secret: client_secret
    mlAPI._post "/oauth/token", null, data, (response) ->
      log "response: #{response}"
      @session.token = response.access_token
      @session.seller_id = response.user_id
      do callback

  ### TODO: Not working ###
  _refresh_token = (callback) ->
    data =
      grant_type: "refresh_token"
      client_id: client_id
      client_secret: client_secret
      refresh_token: @session.refresh_token
    mlAPI._post "/oauth/token", data, callback

  return this

Mercadolivre.Users = {}
Mercadolivre.Apps = {}
Mercadolivre.Categories = {}
Mercadolivre.Listings = {}
Mercadolivre.Locations = {}
Mercadolivre.Currencies = {}
Mercadolivre.Item = {}
Mercadolivre.Search = {}
Mercadolivre.Question = {}
Mercadolivre.Answers = {}
Mercadolivre.Orders = {}
Mercadolivre.Feedback = {}
Mercadolivre.Metrics = {}
Mercadolivre.Shipping = {}

module.exports = Mercadolivre