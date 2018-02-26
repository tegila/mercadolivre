Payments = {}

### @get_question - Fetch one order API Call ###
# _id: message id
Payments.get_payment = (_id, callback) ->
  Auth.get_token ->
    Rest._get "/collections/#{_id}", _.pick(config.session, ['access_token', 'seller_id']), callback 
