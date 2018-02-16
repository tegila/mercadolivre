Users = {}
### @get_user - ###
Users.by_id = (user_id, callback) ->
  Rest._get "/users/#{user_id}", null, (response) ->
    callback response

module.exports = Users
