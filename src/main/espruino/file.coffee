
define 'espruino/file', ->
  (path) ->
    append: (data) -> fs.appendFile(path, data)