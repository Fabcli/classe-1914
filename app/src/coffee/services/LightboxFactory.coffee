angular.module('classe1914.service').factory "LightboxFactory", [
    'Lightbox'
    'Story'
    'User'
    (Lightbox, @Story, @User)->
        new class LightboxFactory
            constructor: ->
                @scope.story        =   @Story
                #The actual sequence
                @scope.sequence     =   @Story.sequence(@chapter.id, @scene.id, @User.sequence)

                @show_nav           =    Lightbox.show_nav or null
                @display_archive    =   no


                # True if we the actual sequence have archives to show
            shouldDisplayArchive = (sequence) =>
                @display_archive = no
                # Id of the actual sequence
                if sequence.archive_params?
                    archives = sequence.archive_params
                    @shouldShowArchiveNav(archives)
                    @display_archive = yes
                @display_archive

            # Display the arrow nav in the archive lightbox
            shouldShowArchiveNav = (images) =>
                Lightbox.show_nav = no
                if images.length > 1
                    Lightbox.show_nav = yes
                Lightbox.show_nav

            # Open the lightbox for archives type
            openLightboxArchives = (archives, index) =>
                Lightbox.openModal(archives, index)

]