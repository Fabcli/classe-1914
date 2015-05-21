angular.module("classe1914.service").factory "ElevateZoom", ->
        new class ElevateZoom

            removeZoom: =>
                # Select all the zoom container
                elements = document.getElementsByClassName('zoomContainer')
                # Loop to remove all the containers
                while(elements.length > 0)
                    elements[0].parentNode.removeChild(elements[0])

# EOF