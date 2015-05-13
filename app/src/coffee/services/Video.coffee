# http://www.videogular.com
angular.module("classe1914.service").factory "Video", ['$sce', ($sce)->
    new class Video

        constructor: ->
            console.log $sce

            @config =
                autoPlay: true
                sources: [
                    {
                        src: $sce.trustAsResourceUrl("http://static.videogular.com/assets/videos/videogular.mp4"), type: "video/mp4"
                    },
                    {
                        src: $sce.trustAsResourceUrl("http://static.videogular.com/assets/videos/videogular.webm"), type: "video/webm"
                    },
                    {
                        src: $sce.trustAsResourceUrl("http://static.videogular.com/assets/videos/videogular.ogg"), type: "video/ogg"
                    }
                ]

                theme:
                    {
                        url: "http://www.videogular.com/styles/themes/default/latest/videogular.css"
                    }

                # TODO : delete => params in the json file
                plugins: {
                    controls: {
                        autoHide: false,
                        autoHideTime: 1000
                    }
                }

]
# EOF
