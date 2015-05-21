# Use ElevateZoom jquery plugin (http://www.elevateweb.co.uk/)
# Directive from http://stackoverflow.com/questions/21353124/angularjs-directive-for-elevatezoom-jquery-plugin

angular.module('classe1914.directive').directive  'ngElevateZoom', [
    ()->
        restrict: "A"
        link: (scope, element, attrs)->
            @UserArchive    = scope.user.case.archive
            @UserCase       = scope.user.case

            #Will watch for changes image inside an archive (caseCtrl)
            attrs.$observe 'zoomImage', ->
                resetData()
                linkElevateZoom()

            scope.$watch (=> @UserArchive.id ), ->
                console.log "changement d'archive"
                resetData()
                linkElevateZoom()

            scope.$watch (=> @UserArchive.zoom ), ->
                console.log "changement de zoom"
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
                        lensSize: 300

            resetData = ->
                element.removeData('elevateZoom')
                element.removeData('zoomImage')
                $('.zoomContainer').remove()

#            scope.$watch (=> @UserArchive.open ), (newValue, oldValue) ->
#                console.log "POUR L'ARCHIVE : "
#                console.log "---oldvalue : "+oldValue
#                console.log "---newValue : "+newValue
#                console.log "fermeture de l'archive" if newValue is false
#                resetData()
#
#            scope.$watch (=> @UserCase.open ), ->
#                console.log "POUR LA VALISE : "
#                #console.log "---oldvalue : "+oldValue
#                #console.log "---newValue : "+newValue
#                console.log "@UserCase.open value : "+scope.user.caseUserCase.open
#                #console.log "fermeture de la valise" if newValue is false
#                resetData()



]