angular.module('classe1914.game').factory 'Shot', [
    'Boot'
    'Preloader'
    (Boot, Preloader)->
        new class Shot

            constructor: ->
                #Création de la variable jeu : "game"
                game = new (Phaser.Game)(600, 400, Phaser.AUTO, 'tir')

                #	On ajoute les différentes étape du jeu.
                game.state.add 'Boot', Boot
                game.state.add 'Preloader', Preloader
    #game.state.add 'MainMenu', JeuDeTir.MainMenu
    #game.state.add 'Game', JeuDeTir.Game

    #	Maintenant on charge l'atat de boot
    #game.state.start 'Boot'
]