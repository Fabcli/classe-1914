angular.module('classe1914.service').factory "Case", [
    '$http'
    '$q'
    'constant.api'
    'Story'
    'User'
    '$filter'
    ($http, $q, api, Story, User, $filter)->

        new class Case
            constructor: ->
                User.caseReady  = no
                console.log User.case

                @archives = false
                #Promise when the archives json is loaded
                @getCase().then(
                    (archives) ->
                        @archives = archives
                        console.log @archives
                    (msg) ->
                        alert(msg)
                )

            getCase : ->
                deferred = $q.defer()
                $http.get(api.case)
                    .success (data) =>
                        @archives = data
                        deferred.resolve(@archives)
                    .error () =>
                        deferred.reject('Failed to load archives')
                deferred.promise
]