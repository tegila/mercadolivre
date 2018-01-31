log = require('debug')('log')

Rest = require "./rest"
config = require "./config"

Auth = {}

### @get_token - Ensure always send last valid token ###
Auth.get_token = (callback) =>
  if config.session.access_token?
    if config.session.access_token.invalid?
      return Auth._refresh_token callback
    callback config.session
  else
    Auth._init_token callback
Auth._change_user_id = (new_user_id) ->
  config.session.seller_id = new_user_id
  
# Get a brand new token from OAUTH2 #
Auth._init_token = (callback) ->
  data =
    grant_type: "client_credentials"
    client_id: config.client_id
    client_secret: config.client_secret
  Rest._post "/oauth/token", null, data, (data) ->
    console.log "response:", data
    config.session = {}
    config.session.access_token = data.access_token
    config.session.seller_id = data.user_id
    console.log config.session
    callback config.session  

### TODO: Not working ###
Auth._refresh_token = (callback) ->
  data =
    grant_type: "refresh_token"
    client_id: config.client_id
    client_secret: config.client_secret
    refresh_token: config.session.refresh_token
  Rest._post "/oauth/token", data, callback

module.exports = Auth