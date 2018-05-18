
Rest_node = ->
  host = "api.mercadolibre.com"

  @_get = (endpoint, query, success) ->
    _request(endpoint, "GET", query, null, success)

  @_post = (endpoint, query, data, success) ->
    _request(endpoint, "POST", query, data, success)

  @_put = (endpoint, query, data, success) ->
    _request(endpoint, "PUT", query, data, success)

  _request = (endpoint, method, query, data, callback) ->

    dataString = JSON.stringify(data)
    headers = {}

    endpoint += '?' + querystring.stringify(query)
    if method is 'GET'
    else
      #dataString = encodeURIComponent dataString
      headers =
        'Content-Type': 'application/json'
        'Content-Length': Buffer.byteLength(dataString, 'utf-8')
        'x-format-new': true
    options = 
      host: host
      path: endpoint
      method: method
      headers: headers

    console.log "#{method} => #{endpoint}"
    req = https.request options, (res) ->
      
      res.setEncoding 'utf-8'
      responseString = ''
      res.on 'data', (data) ->
        responseString += data
      res.on 'end', ->
        try _response = JSON.parse(responseString)
        catch err then callback true, err
        
        if res.statusCode is 401
          return callback true, _response
        else if res.statusCode is 403
          return callback true, _response
        else if res.statusCode is 404
          return callback true, _response
        callback false, _response

    req.write dataString
    do req.end

  return this  


