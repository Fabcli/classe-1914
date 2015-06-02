#angular.module('classe1914.game').factory 'Preloader', [
#    '$filter'
#    'Story'
#    'User'
#    'LoadGameConstant'
#    ($filter, Story, User, LoadGameConstant)->
#        new class Preloader
#            constructor: () ->
#TODO : To delete

#                @media = $filter('media')
#
#                #VARIABLES : Utilisables dans cette étape uniquement (MainMenu.js)
#                @background = null
#                @preloadBar = null
#                @ready = false
#
#
#            preload: ->
#                #--BARRE DE PRECHARGEMENT
#                #	On a les assets chargés dans Boot.js
#                #	soit une barre de préchargement et son conteneur
#                @preloadBar = @add.sprite((@game.width/2)-45, (@game.width/3), 'preloadBar');
#                #Centre la barre depréchargement
#                @preloadBarContainer = @add.sprite((@game.width/2)-45, (@game.width/3), 'preloadBarContainer');
#
#                #	On définit le sprite preloadBar comme un sprite de chargement .
#                # Cela rogne automatiquement le sprite de la largeur max à 0 lorsque les fichiers sont chargés
#                @load.setPreloadSprite(@preloadBar);
#
#                #--ASSETS DU JEU
##                # On récupère les données du jeu actuel
#                @ASSETS = LoadGameConstant.loadAssets()
#                assetsImages     = @ASSETS.images
#                assetsAtlas      = @ASSETS.spriteAtlas
#                assetsSprite    = @ASSETS.spriteSheet
#                assetsAudio      = @ASSETS.audio
#
#                #-- PRECHARGEMENT
#                # Load images, Atlas, Spritesheets and Audio
#                angular.forEach assetsImages, (imagePath, imageName) =>
#                    @load.image imageName,  @media(imagePath)
#                # Load Atlas
#                angular.forEach assetsAtlas, (atlasValues, atlasName) =>
#                    @load.atlas atlasName,  @media(atlasValues.path),  @media(atlasValues.json)
#                # Load Spritesheets
#                angular.forEach assetsSprite, (spriteValues, spriteName) =>
#                    @load.spritesheet spriteName,  @media(spriteValues.path), spriteValues.width, spriteValues.height
#                # Load Audio
#                angular.forEach assetsAudio, (audioArray, audioName) =>
#                    @_a = []
#                    angular.forEach audioArray, (audioPath) =>
#                        @_a.push @media(audioPath)
#                    @load.audio audioName, @_a
#
#
#            create: ->
#                #--On arrete de rogner la barre de préchargement
#                #Une fois le chargement terminé, on désactive le rognage car on va commencer à lancer la boucle de mise a jour (update) afin de décoder la musique (s'il y en a)
#                @preloadBar.cropEnabled = false
#                @ready = true
#
#                #Comme on a pas de musique, on lance le menu principale sans stopper le rognage de la barre de chargement
#                @gameModel = LoadGameConstant.loadModel()
#                if @gameModel is "interactive"
#                    @state.start "Game"
#                else
#                    @state.start "MainMenu"
#
#            update: ->
#]