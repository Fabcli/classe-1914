angular.module('classe1914.service').factory "LightboxFactory", [
    'Lightbox'
    'Story'
    'User'
    (Lightbox, Story, User)->

        new class LightboxFactory

            # True if we the actual sequence have archives to show
            shouldDisplayArchive: () =>
                @display_archive = no
                # Id of the actual sequence
                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                if @sequence.archive_params?
                    @archives = @sequence.archive_params
                    @shouldShowArchiveNav(@archives)
                    @display_archive = yes
                @display_archive

            # Display the arrow nav in the archive lightbox
            shouldShowArchiveNav: (archives) =>
                Lightbox.show_nav = no
                if archives.length > 1
                    Lightbox.show_nav = yes
                Lightbox.show_nav

            # Open the lightbox for archives type
            openLightboxArchives: () =>
                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                @display_archive = @shouldDisplayArchive()
                if @display_archive is true
                    @archives = @sequence.archive_params
                    Lightbox.openModal(@archives, 0)


]