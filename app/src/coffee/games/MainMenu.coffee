angular.module('classe1914.game').factory 'MainMenu', [
    ()->
        new class MainMenu

            constructor: () ->
#                console.log "MainMenu Phaser initialisé"
#                #VARIABLES : Utilisables dans cette étape uniquement (MainMenu.js)
#                @music
#                @playButton
#
#                #game = shot
#
#
#                #VARIABLES : Utilisables dans toutes les étapes (Boot.js, MainMenu.js, Game.js, etc.)
#                @game.fullscreenButton
#                @game.cursors
#                @game.spacebar
#                @game.b_key
#                @game.z_key
#                @game.click





            create: ->
                #--SPRITES
                #	On a déjà tout préchargé, on s'occupe donc directement du menu principal : pas de fonction preload
                # Ici, on peut jouer la musique et ajouter des images comme un titre ou plein d'autres choses
                #this.music = this.add.audio('titleMusic');
                #this.music.play();
                #MODE DE CALCUL PHASER
                #On active le mode arcade
                @physics.startSystem Phaser.Physics.ARCADE
                #SOURIS ET CLAVIERS
                #On active la fonction curseur intégré à Phaser
                @game.cursors = @input.keyboard.createCursorKeys()
                #On definit les variables du clavier
                @game.spacebar = @input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
                @game.b_key = @input.keyboard.addKey(Phaser.Keyboard.B)
                @game.z_key = @input.keyboard.addKey(Phaser.Keyboard.Z)
                @game.f_key = @input.keyboard.addKey(Phaser.Keyboard.F)
                #On crée la variable de click
                @game.click = @input.activePointer
                @startButton()
                #Fonction d'ajout du bouton start
                @initButtonFullScreen()
                #Fonction d'ajout du bouton fullscreen
                #MONDE
                #  Modifie la taille du monde (de la taille de l'image de fond)
                @world.setBounds 0, 0, 1500, 500
                return

            startButton: ->
                @playButton = @add.button(@world.centerX - 96, 300, 'playButton', @startgame, this, 2, 1, 0)
                #On ajoute un bouton qui lancera le jeu avec 3 états
                @playButton.input.useHandCursor = true
                #On lui met un curseur de type main
                return

            initButtonFullScreen: ->
                @game.fullscreenButton = @add.button(550, 12, 'fullscreenButton', @enterFullScreen, this, 1, 1, 0)
                @game.fullscreenButton.input.useHandCursor = true
                #On lui met un curseur de type main
                @game.fullscreenButton.fixedToCamera = true
                #On le fixe à l'écran
                return

            enterFullScreen: ->
                @game.fullscreenButton = @add.button(550, 12, 'fullscreenButton', @quitFullScreen, this, 0, 0, 1)
                @scale.startFullScreen()
                return

            quitFullScreen: ->
                @game.fullscreenButton = @add.button(550, 12, 'fullscreenButton', @enterFullScreen, this, 1, 1, 0)
                @scale.stopFullScreen()
                return

            update: ->
                #	pour faire un menu évolué
                return

            startgame: (pointer) ->
                # Bon, on a cliqué (ou taper) sur le bouton principal, on arrete la musique et on lance le jeu
                @state.start 'Game'
                return
]