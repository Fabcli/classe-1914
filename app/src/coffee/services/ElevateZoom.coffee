angular.module("classe1914.service").factory "ElevateZoom", [
    'User'
    'Notification'
    (User, Notification) ->
        new class ElevateZoom

            removeZoom: =>
                # Select all the zoom container
                elements = document.getElementsByClassName('zoomContainer')
                # Loop to remove all the containers
                while(elements.length > 0)
                    elements[0].parentNode.removeChild(elements[0])

            toggleZoom: =>
                # Change the value for when the case is open
                User.case.archive.zoom = !User.case.archive.zoom
                do @notifZoom

            notifZoom: =>
                if User.case.archive.zoom is true
                    Notification.success "Loupe activée !"
                else
                    Notification.error "Loupe désactivée !"

]

# EOF