# Use ElevateZoom jquery plugin (http://www.elevateweb.co.uk/)
# Directive from http://stackoverflow.com/questions/21353124/angularjs-directive-for-elevatezoom-jquery-plugin

angular.module('classe1914.directive').directive  'ngElevateZoom', [
    '$rootScope'
    ($rootScope)->
        restrict: "A"
        link: (scope, element, attrs)->
            @UserArchive    = scope.user.case.archive
            @UserCase       = scope.user.case

            #Will watch for changes image inside an archive (caseCtrl)
            attrs.$observe 'zoomImage', ->
                resetData()
                linkElevateZoom()

            scope.$watch (=> @UserArchive.id ), ->
                resetData()
                linkElevateZoom()

            scope.$watch (=> @UserArchive.zoom ), ->
                resetData()
                linkElevateZoom()

            linkElevateZoom = ->
                if @UserArchive.zoom is true
                    #Check if its not empty
                    if !attrs.zoomImage
                        return
                    element.attr 'data-zoom-image', attrs.zoomImage
                    $(element).elevateZoom
                        zoomType: 'lens'
                        lensShape: 'round'
                        lensSize: 400

            resetData = ->
                element.removeData('elevateZoom')
                element.removeData('zoomImage')
                $('.zoomContainer').remove()

]
#EOF