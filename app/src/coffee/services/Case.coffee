angular.module('classe1914.service').factory "Case", [
    '$http'
    '$q'
    'constant.api'
    '$filter'
    'User'
    ($http, $q, api, $filter, User)->

        new class Case
            constructor: ->
                #Promise when the archives json is loaded
                @getCase().then(
                    (archives) =>
                        @url = @addUrl(archives)
                        User.case.data = yes
                    (msg) =>
                        alert(msg)
                )
                console.log @
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

            addUrl : (archives)->
                @a = []
                url = $filter('archives')
                angular.forEach (archives), (archive) =>
                    @a.push archive.url=url(archive.name)
                @a


            toggleCase: =>
                User.case.open = !User.case.open
]
#EOF