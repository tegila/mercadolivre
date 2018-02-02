querystring = require('querystring')

Rest = ->
  host = "https://api.mercadolibre.com"

  @_get = (endpoint, query, success) ->
    endpoint += '?' + querystring.stringify(query)
    xhr = new XMLHttpRequest()
    url = "#{host}#{endpoint}"
    xhr.open "GET", url, true
    xhr.setRequestHeader 'x-format-new', true
    xhr.onreadystatechange = ->
      if (this.readyState isnt 4) 
        return
      if (this.status is 200) 
        data = JSON.parse(this.responseText)
        success(data)
    xhr.send null

  @_post = (endpoint, query, data, success) ->
    xhr = new XMLHttpRequest()
    url = "#{host}#{endpoint}"
    xhr.open "POST", url, true
    #xhr.setRequestHeader 'Content-Type', 'application/json'

    xhr.onreadystatechange = ->
      if (this.readyState != 4) 
        return
      if (this.status == 200) 
        data = JSON.parse(this.responseText)
        success(data)
    xhr.send JSON.stringify(data)

  return this  

module.exports = Rest

