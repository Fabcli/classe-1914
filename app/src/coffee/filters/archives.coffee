angular.module("classe1914.filter").filter "archives", [ 'constant.settings', (settings)->
    (input) ->
        settings.mediaUrl + "medias/archives/" +input
]