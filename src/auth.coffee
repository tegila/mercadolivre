log = require('debug')('log')
_ = require "lodash"
querystring = require('querystring')

https = require('https')

Auth = {}

### @get_token - Ensure always send last valid token ###
Auth.get_token = (callback) =>
  if config.session and config.session.access_token?
    if config.session.access_token.invalid?
      return Auth._refresh_token callback
    callback config.session
  else
    Auth.from_client_credentials callback

### @set_token -  ###
Auth.set_token = (new_token) ->
  config.session = new_token

Auth.set_apikey = (keychain) ->
  config.client_id = keychain.client_id
  config.client_secret = keychain.client_secret

# Get a brand new token from OAUTH2 #
Auth.from_client_credentials = (callback) ->
  data =
    grant_type: "client_credentials"
    client_id: config.client_id
    client_secret: config.client_secret
  Rest._post "/oauth/token", null, data, (err, data) ->
    console.log "response:", data
    config.session = {}
    config.session.access_token = data.access_token
    config.session.seller_id = data.user_id
    console.log config.session
    callback err, config.session  

# Get a brand new token from OAUTH2 #
Auth.from_authorization_code = (code, redirect_uri, callback) ->
  data =
    grant_type: "authorization_code"
    client_id: config.client_id
    client_secret: config.client_secret
    code: code
    redirect_uri: redirect_uri
  Rest._post "/oauth/token", data, null, (err, data) ->
    console.log "response:", data
    config.session = {}
    config.session.access_token = data.access_token
    config.session.seller_id = data.user_id
    config.session.refresh_token = data.refresh_token
    console.log config.session
    callback err, config.session  

### TODO: working here ###
Auth.from_refresh_token = (callback) ->
  data =
    grant_type: "refresh_token"
    client_id: config.client_id
    client_secret: config.client_secret
    refresh_token: config.session.refresh_token
  Rest._post "/oauth/token", data, null, (err, data) ->
    console.log "response:", data
    config.session = {}
    config.session.access_token = data.access_token
    config.session.seller_id = data.user_id
    config.session.refresh_token = data.refresh_token
    callback err, config.session
