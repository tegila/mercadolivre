log = require('debug')('log')
_ = require "lodash"

Rest = require "./rest"

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
    Rest._get "/questions/search", data, callback

module.exports = Questions
