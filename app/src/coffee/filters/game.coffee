angular.module("classe1914.filter").filter "game", [ 'constant.settings', (settings)->
  (input) ->
    settings.mediaUrl + "/games/" + input


]