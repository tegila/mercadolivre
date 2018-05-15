Item = {}

### @get_item - ###
Item.get_item = (item_id, callback) ->
  Auth.get_token ->
    Rest._get "/items/#{item_id}", _.pick(config.session, ['access_token', 'seller_id']), callback 

### @from_authenticated_seller - Fetch one order API Call ###
Item.from_authenticated_seller = (seller, filter, callback) ->
  Auth.get_token ->
    data = _.extend {}, filter, config.session
    Utils.paginate Rest._get, "/users/#{seller}/items/search", data, callback

### @status - Fetch one order API Call ###
Item.status = (seller, callback) ->
  Auth.get_token ->
    data = _.extend {}, config.session, {status: 'active'}
    Utils.paginate Rest._get, "/users/#{seller}/items/search", data, (active) ->
      data = _.extend data, {status: 'paused'}
      Utils.paginate Rest._get, "/users/#{seller}/items/search", data, (paused) ->
        data = _.extend data, {status: 'closed'}
        Utils.paginate Rest._get, "/users/#{seller}/items/search", data, (closed) ->
          callback 
            active: active
            paused: paused
            closed: closed

### @get_item_and_description - ###
Item.with_description = (item_id, callback) ->  
  Rest._get "/items/#{item_id}", {}, (err, product) ->
    Rest._get "/items/#{item_id}/description", {}, (err, description) ->
      callback err, _.extend({}, product, description)

Item.description = (item_id, callback) ->
  Rest._get "/items/#{item_id}/description", config.session, callback
    
### @save_item - ###
Item.save = (item, callback) ->
  Auth.get_token ->
    Rest._post "/items", config.session.access_token, item, callback


### @update_item - ###
Item.update = (item_id, callback) ->
  Rest._put "/items/#{item_id}", config.session, callback

Item.get_item_own = (item_id, callback) ->
  Rest._get "/items/#{item_id}", null, callback
