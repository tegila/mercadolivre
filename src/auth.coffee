log = require('debug')('log')

Rest = require "./rest"
rest = Rest "api.mercadolibre.com"

config = require("./config")

Auth = {}

### @get_token - Ensure always send last valid token ###
Auth.get_token = (callback) =>
  if config.session.access_token?
    if config.session.access_token.invalid?
      return Auth._refresh_token callback
    callback config.session
  else
    Auth._init_token callback

# Get a brand new token from OAUTH2 #
Auth._init_token = (callback) ->
  data =
    grant_type: "client_credentials"
    client_id: config.client_id
    client_secret: config.client_secret
  rest._post "/oauth/token", null, data, (response) ->
    log "response:", response
    config.session.access_token = response.access_token
    config.session.seller_id = response.user_id
    callback config.session  

### TODO: Not working ###
Auth._refresh_token = (callback) ->
  data =
    grant_type: "refresh_token"
    client_id: config.client_id
    client_secret: config.client_secret
    refresh_token: config.session.refresh_token
  rest._post "/oauth/token", data, callback

module.exports = Auth