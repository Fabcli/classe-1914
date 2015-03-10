angular.module("classe1914.service").factory "Autoplay", ['User', 'Story', '$rootScope', (User, Story, $rootScope)->
    new class Autoplay

        updateAutoplay: (value)=>
            # New value set
            if value?
                if @soundtrack?
                    @soundtrack.volume(volume)

]