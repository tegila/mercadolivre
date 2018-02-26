Messages = {}

### @get_question - Fetch one order API Call ###
# _id: message id
Messages.get_message = (_id, callback) ->
  Auth.get_token ->
    Rest._get "/messages/#{_id}", _.pick(config.session, ['access_token', 'seller_id']), callback 
