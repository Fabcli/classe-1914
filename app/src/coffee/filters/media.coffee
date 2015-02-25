angular.module("classe1914.filter").filter "media", [ 'constant.settings', (settings)->
    (input) ->
#       console.log("Valeur de input dans media filter: "+input)
       settings.mediaUrl + input


]