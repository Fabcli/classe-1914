angular.module("classe1914.filter").filter "media", [ 'constant.settings', (settings)->
    (input) ->
         settings.mediaUrl + input
]