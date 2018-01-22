Rest = require "./rest"
rest = Rest "api.mercadolibre.com"

Users = {}
### @get_user - ###
Users.by_id = (user_id, callback) ->
  rest._get "/users/#{user_id}", null, (response) ->
    callback response

module.exports = Users