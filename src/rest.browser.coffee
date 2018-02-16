
Rest_browser = ->
  host = "https://api.mercadolibre.com"

  @_get = (endpoint, query, callback) ->
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
        callback(false, data)
      if (this.status is 401) 
        data = this.responseText
        callback(true, data)
    xhr.send null

  @_post = (endpoint, query, data, callback) ->
    xhr = new XMLHttpRequest()
    url = "#{host}#{endpoint}"
    xhr.open "POST", url, true
    #xhr.setRequestHeader 'Content-Type', 'application/json'

    xhr.onreadystatechange = ->
      if (this.readyState != 4) 
        return
      if (this.status is 200) 
        data = JSON.parse(this.responseText)
        callback(false, data)
      if (this.status is 401) 
        data = this.responseText
        callback(true, data)
    xhr.send JSON.stringify(data)

  return this  


