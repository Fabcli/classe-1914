# Based on this module => http://www.videogular.com/docs/#/api/
# Used for the video backround
angular.module("classe1914.service").factory "Video", ['$sce', '$filter', 'User', ($sce, $filter, User)->
    new class Video

        constructor: ->
            @API = null
            @config =
                autoPlay: true

        videoSources: (name) =>
            # Cache video sources to avoid infinite digest iteration
            return @sources if @sources?
            @sources = []
            # Find the directory on amazon S3 with the hero name
            if User.hero?
                n = "/"+User.hero+"/"+name
            else
                n = "/introduction/"+name
            # Add the frontcloud url
            url = $filter('media')(n)
            # list of video extensions
            extensions = ["mp4","ogg","webm"]
            # Create de source array for videogular
            angular.forEach extensions, (extension) =>
                @sources.push src: $sce.trustAsResourceUrl(url+'.'+extension), type: "video/"+extension+""
            @sources

        # Link the vidogular API => need vg-player-ready in the html (http://www.videogular.com/tutorials/videogular-api/)
        onPlayerReady: (API) =>  @API = API

        # Pause the video bg if the case is open
        openCase: =>
            if @API isnt null
                if User.case.open is true
                    @API.pause()
                else
                    @API.play()


]
# EOF
