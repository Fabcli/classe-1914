angular.module('classe1914.game').factory 'Boot', [
    '$filter'
    ($filter)->
        new class Boot
            constructor: (@game) ->


            init: ->
                #  Full screen params
                @scale.scaleMode = Phaser.ScaleManager.NO_SCALE
                @scale.fullScreenScaleMode = Phaser.ScaleManager.SHOW_ALL

                #  Except if the game need the multi touch,
                #  There's only one activate pointer
                @input.maxPointers = 1


                #  Phaser met en pause si on change d'onglet dans le navigateur, on peut le désactiver ici:
                @stage.disableVisibilityChange = true
                if @game.device.desktop

                    #  Si on a des paramètres spécifiques d'ordinateurs, ils peuvent aller ici
                    @scale.pageAlignHorizontally = true
                else

                    #  Idem pour les paramètres mobiles .
                    #  Dans ce cas, on met " la taille du jeu :
                    #  pas plus bas que 480x260 et ne dépasse pas 1024x768 " .
                    @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
                    @scale.setMinMax 480, 260, 1024, 768
                    @scale.forceLandscape = true
                    @scale.pageAlignHorizontally = true
                    @scale.setScreenSize true
                    @scale.refresh()

            preload: ->

                #  Ici, nous chargeons les assets nécessaires pour notre Preloader
                #  (dans ce cas une barre de chargement et son conteneur)
                @load.image 'preloadBar', $filter('game')('img/game_common/c14g_preloader-bar.png')
                @load.image 'preloadBarContainer', $filter('game')('img/game_common/c14g_preloader-bar-container.png')

            create: ->

                # A ce niveau, les assets de préchargement sont chargés dans le cache ,
                # nous avons mis les paramètres de jeu
                #
                # Maintenant nous allons commencer le vrai préchargement
                @state.start 'Preloader'
]