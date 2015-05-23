angular.module('classe1914.game').factory 'Preloader', [
    'constant.games'
    (games)->
        new class Preloader
            constructor: (game) ->
                #VARIABLES : Utilisables dans cette étape uniquement (MainMenu.js)
                @background = null
                @preloadBar = null
                @ready = false

            preload: ->
                #--BARRE DE PRECHARGEMENT
                #	On a les assets chargés dans Boot.js
                #	soit une barre de préchargement et son conteneur
                @preloadBar = @add.sprite((@game.width/2)-45, (@game.width/3), 'preloadBar');
                #Centre la barre depréchargement
                @preloadBarContainer = @add.sprite((@game.width/2)-45, (@game.width/3), 'preloadBarContainer');
                #Centre e conteneur
                
                #	On définit le sprite preloadBar comme un sprite de chargement .
                # Cela rogne automatiquement le sprite de la largeur max à 0 lorsque les fichiers sont chargés
                @load.setPreloadSprite(@preloadBar);
                
                
                #--ASSETS A PRECHARGER
                #	Ici, on va charger les restes des assets nécessaires au jeu
                @load.image('bg','medias/games/img/game_shot/decor1test-nuitW.jpg');
                @load.image('target', 'medias/games/img/game_shot/cible.png');
                @load.image('shot','medias/games/img/game_shot/particles/shot.png');
                @load.image('timeBar', 'medias/games/img/game_shot/timebar.png');
                @load.image('timeContainer','medias/games/img/game_shot/timebar-container.png');
                @load.image('curtain','medias/games/img/game_common/curtain_black.png');
                @load.atlas('shotgun', 'medias/games/img/game_shot/sprites/shotgun.png', 'medias/games/data/game_shot/lebel.json');
                @load.spritesheet('explosion', 'medias/games/img/game_shot/sprites/explosion.png', 36, 51);
                @load.spritesheet('playButton', 'medias/games/img/game_common/sprites/playButton.png', 193, 71);
                @load.spritesheet('fullscreenButton', 'medias/games/img/game_common/sprites/fullscreenButton.png', 36, 36);
                @load.audio('shot', ['medias/games/sounds/game_shot/shot.mp3','medias/games/sounds/game_shot/shot.ogg']);
                @load.audio('break_target', ['medias/games/sounds/game_shot/ecrase_pot_yaourt.mp3','medias/games/sounds/game_shot/ecrase_pot_yaourt.ogg']);
                #@load.bitmapFont('caslon', 'fonts/caslon.png', 'fonts/caslon.xml');

                #Launch the next function

            create: ->
                #--On arrete de rogner la barre de préchargement
                #Une fois le chargement terminé, on désactive le rognage car on va commencer à lancer la boucle de mise a jour (update) afin de décoder la musique (s'il y en a)
                @preloadBar.cropEnabled = false
                @ready = true

                #Comme on a pas de musique, on lance le menu principale sans stopper le rognage de la barre de chargement
                @state.start "MainMenu"

            update: ->
]