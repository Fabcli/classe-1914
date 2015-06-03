# Use ElevateZoom jquery plugin (http://www.elevateweb.co.uk/)
# Directive from http://stackoverflow.com/questions/21353124/angularjs-directive-for-elevatezoom-jquery-plugin

angular.module('classe1914.directive').directive  'ngElevateZoom', [
    '$rootScope'
    'ElevateZoom'
    ($rootScope, ElevateZoom)->
        restrict: "A"
        link: (scope, element, attrs)->
            @UserArchive    = $rootScope.user.case.archive
            @UserCase       = $rootScope.user.case

            #Will watch for changes image inside an archive (caseCtrl)
            attrs.$observe 'zoomImage', ->
                resetData()
                linkElevateZoom()

            scope.$watch (=> @UserArchive.id ), ->
                resetData()
                linkElevateZoom()

            # Reset when the case is opened or closed
            scope.$watch (=> @UserCase.open ), ->
                resetData()

            # Relink when the zoom is toggled and notify for story archive
            scope.$watch (=> @UserArchive.zoom ), ->
                #if $rootScope.user.case.open is false
                #    ElevateZoom.notifZoom()
                resetData()
                linkElevateZoom()

            # Relink when the zoom is toggled and notify for story archive
            scope.$watch (=> @UserCase.zoom ), ->
                #if $rootScope.user.case.open is true
                #    ElevateZoom.notifZoom()
                resetData()
                linkElevateZoom()

            linkElevateZoom = ->
                if @UserCase.zoom is true and @UserCase.open is true || @UserArchive.zoom is true and @UserCase.open is false
                    #Check if its not empty
                    if !attrs.zoomImage
                        return
                    element.attr 'data-zoom-image', attrs.zoomImage
                    $(element).elevateZoom
                        zoomType: 'lens'
                        lensShape: 'round'
                        lensSize: 500

            resetData = ->
                element.removeData('elevateZoom')
                element.removeData('zoomImage')
                $('.zoomContainer').remove()

]
#EOF