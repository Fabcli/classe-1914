angular.module('classe1914.service').factory "Archive", [
    'Lightbox'
    'Story'
    'User'
    'Notification'
    '$filter'
    (Lightbox, Story, User, Notification, $filter)->

        new class Archive
            constructor: ->
                User.archiveReady = no

            getArchive: () =>
                return @archives if @archives?
                @archives = []
                @chapter = Story.chapters[0]
                angular.forEach @chapter.scenes, (scene)=>
                    # First archive if there's one in the decor
                    if scene.decor? and scene.decor[0].archive?
                        @archives.push scene.decor[0].archive
                        #console.log("There's archives in the decor")
                    # Look into each scene's sequence to find the new background
                    angular.forEach scene.sequence, (sequence)=>
                        if sequence.archive?
                            # Add the archive to archives list
                            @archives.push sequence.archive
                @getArchivesUrl(@archives)



            getArchivesUrl: (archives) =>
                @archive_url = []
                angular.forEach archives, (archive)=>
                    angular.forEach archive, (a)=>
                        @archive_url.push $filter('media')(a.src)
                @archive_url


            # True if we the actual sequence have archives to show
            shouldDisplayArchive: () =>
                @display_archive = no
                @archives = @sequence.archive
                if @archives?
                    @shouldShowArchiveNav(@archives)
                    @display_archive = yes
                @display_archive

            # Display the arrow nav in the archive lightbox
            shouldShowArchiveNav: (archives) =>
                Lightbox.show_nav = no
                if archives.length > 1
                    Lightbox.show_nav = yes
                Lightbox.show_nav

            archiveNotification: ()=>
                @notification = @sequence.archive_button
                @display_archive = @shouldDisplayArchive()
                if @display_archive is true
                    Notification.primary(@notification)

            # Open the lightbox for archives type
            openLightboxArchives: () =>
                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                @display_archive = @shouldDisplayArchive()
                if @display_archive is true
                    @archives = @sequence.archive
                    Lightbox.openModal(@archives, 0)
]