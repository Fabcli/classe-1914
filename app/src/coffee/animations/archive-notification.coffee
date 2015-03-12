angular.module("classe1914.animation").animation '.archive-notification-animation', ["$timeout", "constant.settings", ($timeout, settings)->

    enter: (element, done) ->
        element.css("opacity", 0)
        $timeout ->
            jQuery(element[0]).animate opacity: 1, settings.archiveNotification/3, done
            # Wait 3000 seconds before the start of the animation
        , settings.archiveNotification/3
        # Catch canceling
        (isCanceled)-> (jQuery(element[0]).stop() if isCanceled)

    leave: (element, done) ->
        element.css("opacity", 1)
        jQuery(element[0]).animate opacity: 0, settings.archiveNotification/3, done
        # Catch canceling
        (isCanceled)-> (jQuery(element[0]).stop() if isCanceled)
]
# EOF