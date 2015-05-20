class ZoomCtrl
    @$inject: ['$scope', '$element', '$attrs', 'User', 'Notification']

    constructor: (@scope, @element, @attrs, @User, @Notification)->
        @scope.user       =   @User

        @userZoom = @User.case.archive.zoom = true

        @scope.removeZoom = =>
            document.getElementsByClassName('zoomContainer').remove()





angular.module('classe1914').controller("ZoomCtrl", ZoomCtrl)
# EOF
