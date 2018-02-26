
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

### @get_question - Fetch one order API Call ###
# question_id: question id
Questions.get_question = (question_id, callback) ->
  Auth.get_token ->
    Rest._get "/questions/#{question_id}", _.pick(config.session, ['access_token', 'seller_id']), callback 

