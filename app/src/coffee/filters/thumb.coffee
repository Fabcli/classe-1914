angular.module("classe1914.filter").filter "thumb", [ 'constant.settings', (settings)->
  (input) ->
    settings.mediaUrl + "/thumbs" + input


]