Utils = {}

### @_is_updated_version compare two objects ###
Utils.is_an_updated_version = (obj1, obj2) ->
  if obj1.date_created is obj2.date_created
    return true
  else
    return false 

### @_is_it_the_same compare two objects ###
Utils.is_it_the_same = (obj1, obj2) ->
  if obj1.last_updated? and obj1.last_updated is obj2.last_updated
    return true
  else if obj1.date_last_updated? obj1.date_last_updated is obj2.date_last_updated
    return true
  else
    return false

### @compare two lists and return the result ###
Utils.compare = (old_list, new_list) ->
  ### @result ###
  result = 
    insert: new Array()
    updated:  new Array()
    #deleted: new Array()

  for i in [0..new_list.length-1]
    for j in [0..old_list.length-1]
      if @_is_an_updated_version old_list[j], new_list[i]
        if not @_is_it_the_same old_list[j], new_list[i]
          result.updated.push _.extend {}, old_list[j], new_list[i]
        break
      else if j is old_list.length-1
        result.insert.push new_list[i]
  result.all_changes = _.extend {}, result.insert, result.updated
  #result.deleted = _.differenceBy old_list, new_list, @_is_an_updated_version
  return result

Utils.paginate = (fn, url, params, callback, _yield) ->
  _yield = _yield or []
  defaults = 
    offset: 0
    limit: 50
  params = _.extend {}, defaults, params

  log url, params
  fn url, params, (res) ->
    log res.results[0]
    _yield = _.union _yield, res.results
    params.offset += res.paging.limit

    if res.paging.total > res.paging.offset+res.paging.limit
      #callback _yield
      Utils.paginate fn, url, params, callback, _yield
    else
      callback _yield
