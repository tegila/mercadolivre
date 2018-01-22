log = require('debug')('log')
_ = require "lodash"

Rest = require "./rest"
rest = Rest "api.mercadolibre.com"

Auth = require './auth'
Utils = require './utils'
config = require './config'

Questions = {}

### @unanswered - ###
#/questions/search?access_token=...&seller_id=...&status=UNANSWERED
Questions.unanswered = (callback) ->
  Auth.get_token ->
  	data =
      "access_token": config.session.access_token
      "seller": config.session.seller_id
      "status": "UNANSWERED"
    rest._get "/questions/search", data, callback

module.exports = Questions
