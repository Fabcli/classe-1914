angular.module('classe1914.service').factory "Case", [
    '$http'
    '$q'
    'constant.api'
    'User'
    ($http, $q, api, User)->

        new class Case
            constructor: ->
                #Promise when the archives json is loaded
                @getCase().then(
                    (archives) =>
                        @archives = archives
                        User.case.data = yes
                    (msg) =>
                        alert(msg)
                )
                @

            getCase : ->
                #Promise to valid the case data
                deferred = $q.defer()
                #Ajax request to load the case data
                $http.get(api.case)
                    .success (data) =>
                        @archives = data
                        deferred.resolve(@archives)
                    .error () =>
                        deferred.reject('Failed to load case')
                deferred.promise

            toggleCase: =>
                User.case.open = !User.case.open
]
#EOF