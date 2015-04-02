angular.module('classe1914.service').factory "Archive", [
    'Lightbox'
    'User'
    'Story'
    'Case'
    'Notification'
    '$filter'
    (Lightbox, User, Story, Case, Notification, $filter)->

        new class Archive
            constructor: ->

            # Load an array with the archives_id to unlocked in the current chapter
            # In order to preload the images
            # The chapter must be send in argument
            getChapterCase: (chapter) =>
                # For the moment, there's no case to unlocked during the introduction
                if User.hero isnt null
                    # Create un  User parameter with the archive in case during the chapter
                    # TODO : checked if it's necessary
                    @chapterCase = User.case.thisChapter = []
                    angular.forEach chapter.scenes, (scene)=>
                        # First archive or case to unblocked if there's one in the decor
                        if scene.decor? and scene.decor[0].case?
                            angular.forEach scene.decor[0].case , (c) =>
                                @chapterCase.push c if c not in @chapterCase
                        # Look into each scene's sequence to find the new archive
                        angular.forEach scene.sequence, (sequence)=>
                            if sequence.case?
                                angular.forEach sequence.case, (c)=>
                                    @chapterCase.push c if c not in @chapterCase
                    console.log "VALEUR DES ARCHIVES A DEBLOQUER dans le valise"
                    console.log @chapterCase
                    @chapterCase

            # Get all the archives' params filter by id (with an id's array)
            getArchives: (Ids) =>
                @a = []
                archives = Case.archives
                angular.forEach Ids, (id) =>
                    @a.push archive for archive in archives when archive.id is id
                @a

            # Get the url of images filter by id (with an id's array)
            getArchivesUrl: (Ids) =>
                @archiveUrl = []
                archives = Case.archives
                angular.forEach Ids, (id) =>
                     @pushArchiveUrl archive.name for archive in archives when archive.id is id
                @archiveUrl

            pushArchiveUrl: (name) ->
                @archiveUrl.push $filter('archives')(name) if $filter('archives')(name) not in @archiveUrl


            # True if the actual sequence have archives to show
            shouldDisplayArchive: () =>
                @display_archive = no
                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                @archives = @sequence.archive
                if @archives?
                    @shouldShowArchiveNav(@archives)
                    @display_archive = yes
                @display_archive

            # Display the arrow nav in the archive lightbox
            # if there more than one archive to show
            shouldShowArchiveNav: (archives) =>
                Lightbox.show_nav = no
                if archives.length > 1
                    Lightbox.show_nav = yes
                Lightbox.show_nav

            archiveNotification: ()=>
                @notification = @sequence.archive_button
                @display_archive = @shouldDisplayArchive()
                @notification = @sequence.archive_button
                if @display_archive is true
                    Notification.primary(@notification)

            # Open the lightbox for archives
            openArchive: () =>
                @display_archive = @shouldDisplayArchive()
                if @display_archive is true
                    console.log "valeur de la sequence"+@sequence.archive
                    @archives = @getArchives(@sequence.archive)
                    Lightbox.openModal(@archives, 0)

            unlockArchiveInCase: () =>
                console.log "archive debloqué"
]