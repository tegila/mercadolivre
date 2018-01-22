log = require('debug')('log')

querystring = require('querystring')
https = require('https')

Rest = (host) ->
  @_get = (endpoint, query, success) ->
    _request(endpoint, "GET", query, null, success)

  @_post = (endpoint, query, data, success) ->
    _request(endpoint, "POST", query, data, success)

  _request = (endpoint, method, query, data, success) ->

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
        success JSON.parse(responseString)

    req.write dataString
    do req.end

  return this  

module.exports = Rest

