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
                        @liens = @addUrl(archives)
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

            addUrl : (archives)->
                @a = []
                url = $filter('archives')
                angular.forEach (archives), (archive) =>
                    # Check if there's several images for the archive
                    if angular.isArray(archive.name) is true
                        # Clean the a array and create a b one
                        @b = []
                        names = archive.name
                        angular.forEach (names), (name) =>
                            @b.push url(name)
                        @addOtherUrl(@b, archive)
                    # If not, add an url param with the media archive filter
                    else
                        @a.push archive.url=url(archive.name)
                @a

            addOtherUrl : (urls, archive) ->
                # Return the first url
                archive.url = urls[0]
                # Add the images number TODO : this param "images number" to delete
                archive.images = urls.length
                # Delete first value named url
                #urls.shift()
                # add other urls
                archive.allUrl = urls


            toggleCase: =>
                User.case.open = !User.case.open
]
#EOF