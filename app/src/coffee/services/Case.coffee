angular.module('classe1914.service').factory "Case", [
    '$http'
    '$q'
    'constant.api'
    'User'
    ($http, $q, api, User)->

        new class Case
            constructor: ->
                User.caseReady  = no
                @caseData = no

                @archives = []
                #Promise when the archives json is loaded
                @getCase().then(
                    (archives) =>
                        @archives = archives
                        @caseData = yes
                    (msg) =>
                        alert(msg)
                )
                @

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