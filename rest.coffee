querystring = require('querystring')
https = require('https')

Rest = (host) ->
  @_put = (endpoint, query, data, success) ->
    _request(endpoint, "PUT", query, data, success)

  @_get = (endpoint, query, success) ->
    _request(endpoint, "GET", query, null, success)

  @_post = (endpoint, query, data, success) ->
    _request(endpoint, "POST", query, data, success)

  _request = (endpoint, method, query, data, success) ->
    dataString = JSON.stringify(data)
    headers = {}
    if method is 'GET'
      endpoint += '?' + querystring.stringify(query)
    else
      headers =
        'Content-Type': 'application/json'
        'Content-Length': dataString.length
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
        success JSON.parse(responseString)

    req.write dataString or ""
    do req.end

  return this  

module.exports = Rest

