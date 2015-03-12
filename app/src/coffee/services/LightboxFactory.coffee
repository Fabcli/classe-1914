angular.module('classe1914.service').factory "LightboxFactory", [
    'Lightbox'
    'Story'
    'User'
    'Notification'
    (Lightbox, Story, User, Notification)->

        new class LightboxFactory
            constructor: ->
                # Id of the actual sequence
                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                @notification =  @sequence.archive_button


            # True if we the actual sequence have archives to show
            shouldDisplayArchive: () =>
                @display_archive = no
                @archives = @sequence.archive_params
                if @archives?
                    @shouldShowArchiveNav(@archives)
                    console.log("killer ?")
                    @display_archive = yes
                @display_archive

            # Display the arrow nav in the archive lightbox
            shouldShowArchiveNav: (archives) =>
                Lightbox.show_nav = no
                if archives.length > 1
                    Lightbox.show_nav = yes
                Lightbox.show_nav

            archiveNotification: (notification)=>
                console.log("Affiche la notif: "+notification)
                Notification.primary(notification)

            # Open the lightbox for archives type
            openLightboxArchives: () =>
                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                @display_archive = @shouldDisplayArchive()
                if @display_archive is true
                    @archives = @sequence.archive_params
                    Lightbox.openModal(@archives, 0)
]