angular.module("classe1914.service").factory "ElevateZoom", ->
        new class ElevateZoom

            removeZoom: =>
                elements = document.getElementsByClassName('zoomContainer')
                while(elements.length > 0)
                    elements[0].parentNode.removeChild(elements[0])

# EOF