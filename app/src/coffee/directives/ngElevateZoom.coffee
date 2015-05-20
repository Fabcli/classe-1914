# Use ElevateZoom jquery plugin (http://www.elevateweb.co.uk/)
# Directive from http://stackoverflow.com/questions/21353124/angularjs-directive-for-elevatezoom-jquery-plugin

angular.module('classe1914.directive').directive  'ngElevateZoom', [
    ()->
        restrict: "A"
        controller: "ZoomCtrl"
        link: (scope, element, attrs)->
            userZoom = scope.user.case.archive.zoom
            #Will watch for changes on the attribute
            attrs.$observe 'zoomImage', ->
                if userZoom is true
                    linkElevateZoom()

            linkElevateZoom = ->
                #Check if its not empty
                if !attrs.zoomImage
                    return
                element.attr 'data-zoom-image', attrs.zoomImage
                $(element).elevateZoom
                    zoomType: 'lens'
                    lensShape: 'round'
                    lensSize: 200

]