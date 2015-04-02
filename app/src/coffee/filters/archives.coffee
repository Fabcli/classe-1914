angular.module("classe1914.filter").filter "archives", [ 'constant.settings', (settings)->
    (name) ->
        settings.mediaUrl + "/archives/" +name+ ".jpg"
]