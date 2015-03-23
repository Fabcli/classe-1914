angular.module('classe1914.game').factory 'Preloader', [
    'User'
    (User)->

        new class Preloader

            constructor: (game) ->
                @background = null
                @preloadBar = null
                @ready = false



            preload: ->
                #--BARRE DE PRECHARGEMENT
                #	On a les assets chargés dans Boot.js
                #	soit une barre de préchargement et son conteneur
                @preloadBar = @add.sprite(@game.width / 2 - 45, @game.width / 3, 'preloadBar')
                #Centre la barre depréchargement
                @preloadBarContainer = @add.sprite(@game.width / 2 - 45, @game.width / 3, 'preloadBarContainer')
                #Centre e conteneur
                #	On définit le sprite preloadBar comme un sprite de chargement .
                # Cela rogne automatiquement le sprite de la largeur max à 0 lorsque les fichiers sont chargés
                @load.setPreloadSprite @preloadBar


                #--ASSETS A PRECHARGER
                #	Ici, on va charger les restes des assets nécessaires au jeu
                @load.image 'bg', 'img/game_shot/decor1test-nuitW.jpg'
                #this.load.image('planks', 'img/game_shot/planks.png');
                @load.image 'target', 'img/game_shot/cible.png'
                @load.image 'shot', 'img/game_shot/particles/shot.png'
                @load.image 'timeBar', 'img/game_shot/timebar.png'
                @load.image 'timeContainer', 'img/game_shot/timebar-container.png'
                @load.image 'curtain', 'img/game_common/curtain_black.png'
                @load.atlas 'shotgun', 'img/game_shot/sprites/shotgun.png', 'data/game_shot/lebel.json'
                #this.load.spritesheet('explosion', 'img/game_shot/sprites/explosion.png', 36, 51);
                @load.spritesheet 'playButton', 'img/game_common/sprites/playButton.png', 193, 71
                @load.spritesheet 'fullscreenButton', 'img/game_common/sprites/fullscreenButton.png', 36, 36
                @load.audio 'shot', [
                    'sounds/game_shot/shot.mp3'
                    'sounds/game_shot/shot.ogg'
                ]
                @load.audio 'break_target', [
                    'sounds/game_shot/ecrase_pot_yaourt.mp3'
                    'sounds/game_shot/ecrase_pot_yaourt.ogg'
                ]
                #this.load.bitmapFont('caslon', 'fonts/caslon.png', 'fonts/caslon.xml');
                return

            create: ->
                #--On arrete de rogner la barre de préchargement
                #	Une fois le chargement terminé, on désactive le rognage car on va commencer à lancer la boucle de mise a jour (update) afin de décoder la musique (s'il y en a)
                @preloadBar.cropEnabled = false
                @ready = true
                #Comme on a pas de musique, on lance le menu principale sans stopper le rognage de la barre de chargement
                @state.start 'MainMenu'
                return

            update: ->
                #	On a pas réellement besoin de faire cela , mais je trouve cela donne une expérience de jeu beaucoup plus fluide .
                #	Fondamentalement, on va attendre le décodage du fichier audioavant de lancer le menu principal (MainMenu) .
                #On peut directement aller au menu principal mais on risque d'avoir qq secondes de retard le temp[s de decodage du mp3, si on a besoin de la musique pour être synchro avec le menu, c'est la meilleure solution : décoder d'abord puis lancer le mainMenu
                #	Si on a pas de musique (comme pour le moment), on met le game.start.start dnas la fonction create
                #	the update function completely.
                #		if (this.cache.isSoundDecoded('titleMusic') && this.ready == false)
                #		{
                #			this.ready = true;
                #			this.state.start('MainMenu');
                #		}
                return

]