class GameCtrl
    @$inject: ['$scope', 'Story', 'User', 'Boot', 'MainMenu', 'LoadGameConstant', '$filter', 'Notification']
    constructor: (@scope, @Story, @User, @Boot, @MainMenu, @LoadGameConstant, @filter, @Notification) ->
        @scope.story            =   @Story
        @scope.User             =   @User

        @scope.LoadGameConstant =   @LoadGameConstant
        @scope.Boot             =   @Boot
        @scope.MainMenu         =   @MainMenu
        @scope.Notification     =   @Notification

        @gameModel  = @scope.gameModel
        @gameName   = @scope.gameName

        @media = @filter('media')

        do @LaunchGame

    LaunchGame: ()=>
        @DestroyGame(@game) if @game?
        @RemoveCanvas

        @game = new Phaser.Game('100%', '100%', Phaser.AUTO, 'gameCanvas')

        # Preload, settings & Menu
        @game.state.add('Boot', @Boot)
        @game.state.add('Preloader', @Preloader)
        @game.state.add('MainMenu', @MainMenu) if @gameModel isnt 'interactive'

        # Launch different game
        @game.state.add('Game', @Shot) if @gameModel is 'shot'
        @game.state.add('Game', @Interactive) if @gameModel is 'interactive'

        @game.state.start('Boot')

    DestroyGame: (game) =>
        game.destroy()

    RemoveCanvas: =>
        # Select all the canvas in the document
        canvas = document.getElementsByTagName('canvas')
        if canvas?
            # Loop to remove all the canvas
            while(canvas.length > 0)
                canvas[0].parentNode.removeChild(canvas[0])

    Preloader: =>
        preload: =>
            #--BARRE DE PRECHARGEMENT
            #	On a les assets chargés dans Boot.js
            #	soit une barre de préchargement et son conteneur
            @preloadBar = @game.add.sprite((@game.width/2)-45, (@game.width/3), 'preloadBar');
            #Centre la barre depréchargement
            @preloadBarContainer = @game.add.sprite((@game.width/2)-45, (@game.width/3), 'preloadBarContainer');

            #	On définit le sprite preloadBar comme un sprite de chargement .
            # Cela rogne automatiquement le sprite de la largeur max à 0 lorsque les fichiers sont chargés
            @game.load.setPreloadSprite(@preloadBar);

            #--ASSETS DU JEU
            #                # On récupère les données du jeu actuel
            @ASSETS = @LoadGameConstant.loadAssets(@gameModel,@gameName)
            assetsImages     = @ASSETS.images
            assetsAtlas      = @ASSETS.spriteAtlas
            assetsSprite    = @ASSETS.spriteSheet
            assetsAudio      = @ASSETS.audio

            #-- PRECHARGEMENT
            # Load images, Atlas, Spritesheets and Audio
            angular.forEach assetsImages, (imagePath, imageName) =>
                @game.load.image imageName,  @media(imagePath)
            # Load Atlas
            angular.forEach assetsAtlas, (atlasValues, atlasName) =>
                @game.load.atlas atlasName,  @media(atlasValues.path),  @media(atlasValues.json)
            # Load Spritesheets
            angular.forEach assetsSprite, (spriteValues, spriteName) =>
                @game.load.spritesheet spriteName,  @media(spriteValues.path), spriteValues.width, spriteValues.height
            # Load Audio
            angular.forEach assetsAudio, (audioArray, audioName) =>
                @_a = []
                angular.forEach audioArray, (audioPath) =>
                    @_a.push @media(audioPath)
                @game.load.audio audioName, @_a


        create: =>
            #--On arrete de rogner la barre de préchargement
            #Une fois le chargement terminé, on désactive le rognage car on va commencer à lancer la boucle de mise a jour (update) afin de décoder la musique (s'il y en a)
            @preloadBar.cropEnabled = false
            @game.ready = true

            #Comme on a pas de musique, on lance le menu principale sans stopper le rognage de la barre de chargement
            if @gameModel is "interactive"
                @game.state.start "Game"
            else
                @game.state.start "MainMenu"

    Shot: =>
        create: =>
            #On recupère les réglage du jeu dans la sequence
            @SETTINGS = @LoadGameConstant.loadSettings(@gameModel,@gameName)


            #On active le mode arcade
            @game.physics.startSystem Phaser.Physics.ARCADE


            @spacebar = @game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
            @b_key = @game.input.keyboard.addKey(Phaser.Keyboard.B)
            @z_key = @game.input.keyboard.addKey(Phaser.Keyboard.Z)
            @cursors = @game.input.keyboard.createCursorKeys()
            #@click = @game.input.activePointer

            #  Modifie la taille du monde (de la taille de l'image de fond)
            @game.world.setBounds 0, 0, @SETTINGS.world.width, @SETTINGS.world.height

            # Coordonnées du fusil
            @shotgunPosX = @game.width/2
            @shotgunPosY = @game.height+(0.015*@game.height)

            #On met le score à 0
            @score = 0
            @gameover = false #Le jeu n'est pas terminé
            @totalTargets = @SETTINGS.target.quantity #On définit le nombre de cibles
            @timerDuration = @SETTINGS.timer.duration #On définit le jeu à 30s
            @buildWorld() #On lance le fonction de création du monde
            @buildScore() #On lance la fonction de création du score
            @buildTimer() #On lance la fonction de création du timer

        #-----------------------------------//
        update: =>
            if @gameover is false
                #console.log "scaleFactor"+@game.scale
                @moveWorld() #Le déplacement dans le monde
                @updateTimer() #On lance le timer
                @collideTarget() #Fonction d'écoute de la collision tir-cible



        render: =>

            @game.debug.text('Position de la cam => x: '+@game.camera.x+',y: '+ @game.camera.y, @game.width/2, 32);
            @game.debug.text('Taille du monde: ' + @game.world.width, @game.width/2, 64);
            @game.debug.text('Source Ratio: ' + @game.scale.sourceAspectRatio, @game.width/2, 96);
            @game.debug.text('Ratio: ' + @game.scale.aspectRatio, @game.width/2, 128);
            @game.debug.text('Movement x: ' +@movementX, @game.width/2, 160);
            @game.debug.text('Movement Y: ' +@movementY, @game.width/2, 192);
            @game.debug.text('input x: ' +@game.input.mouse.event.movementX, @game.width/2, 228);
            @game.debug.text('input y: ' +@game.input.mouse.event.movementY, @game.width/2, 260);

    #--- SHOT ---
    # SHOT - CREATE FUNCTION

    buildWorld: =>
        @game.add.sprite 0, 0, "bg" #On ajoute l'image de fond
        @ambianceSound() #On rajoute la music d'ambiance
        @buildTargets() #Fonction de création des cibles
        @buildExplosion() #Fonction de création de l'anim d'explosion de la balle
        @buildShotgun() #Fonction d'ajout du fusil
        @activeShot() #Fonction qui active le tir (les commandes clic et barre d'espace)
        @cameraSettings() #Fonction de réglages de la caméra

    ambianceSound: =>
        ambiance        = @game.add.audio("ambiance") #On ajoute le son
        ambiance.volume = @SETTINGS.audio.ambiance.volume
        ambiance.loop   = @SETTINGS.audio.ambiance.loop
        ambiance.play()
        # Corrige un bug sous chrome qui embêche à la music de boucler
        ambiance.onLoop.add(->
            ambiance.play()
        )

    buildTargets: =>
        @targetGroup = @game.add.group() #On déclare le groupe composé des cibles
        @targetGroup.enableBody = true
        i = 0

        while i < @totalTargets
            #targetX = Math.floor((@shotgunPosX/2) + Math.random() * (@game.world.width-(@shotgunPosX/2))) #Abscisses aux extremité du monde - 1/2 position du fusil
            targetX = @game.rnd.realInRange(@shotgunPosX, @game.world.width-@shotgunPosX) #//Ordonnées entre 280 et 380. REM: Les deux méthodes pour x et y donne le même résultat.
            targetY = @game.rnd.realInRange(@shotgunPosY-120, @shotgunPosY-20) #//Ordonnées entre 280 et 380. REM: Les deux méthodes pour x et y donne le même résultat.
            t = @targetGroup.create(targetX, targetY, "target")
            t.anchor.setTo 0.5, 0.5 #On centre le point d'ancrage des cibles
            scale = @game.rnd.realInRange(0.2, 1.0) #On fait des tailles différentes (coeff mini, coeff max)
            t.scale.x = t.scale.y = scale # On affecte ca aux hauteurs et largeurs
            @game.physics.enable t, Phaser.Physics.ARCADE #Les comportements d'arcades
            t.enableBody = true #On active le body à chaque cible
            i++

    buildShotgun: =>
        @shotgun = @game.add.sprite(@shotgunPosX, @shotgunPosY, "shotgun") #On ajoute le fusil
        @shotgun.fixedToCamera = true #On le fixe à l'écran
        @shotgun.anchor.setTo 0.4, 0.8 #On l'ancre par rapport au centre bas
        @shotgun.animations.add "shotAnim", [ 0, 1, 2, 3, 0 ], 60, false #Ajoute l'animation et on ne la lit pas en boucle

    buildExplosion: =>
        @shotExplosion = @game.add.emitter(@shotgunPosX-11, @shotgunPosY-125, 100) #Ajoute l'emetteur des particules (x,y,nombre maximum de particules créées)
        @shotExplosion.fixedToCamera = true #On le fixe à l'écran
        #@shotExplosion.cameraOffset = new Phaser.Point(949,895) #On fixe le bug de Phaser 2.3.0 qui ne recopie pas les coordonnées apres avoir fixé à la caméra
        @shotExplosion.minParticleScale = 0.2 #Coeff miniùum de taille des particules
        @shotExplosion.maxParticleScale = 2 #Coeff maximum de taille des particules
        @shotExplosion.minParticleSpeed.setTo -100, 100 #Vélocité minimum
        @shotExplosion.maxParticleSpeed.setTo 100, -100 #Vélocité max
        @shotExplosion.makeParticles "shot" #On crêe les particules à partir de l'image 'shot'

    #Reglages de Caméra------
    cameraSettings: =>
        @game.camera.focusOnXY @game.world.centerX, @game.world.centerY #On centre la camera dans le monde


    #Timer et score------
    buildScore: =>
        @scoreStyle =
            font: "16px Courier"
            fill: "#fff"
            stroke: "#6a9f3a"
            strokeThickness: 1
            align: "center"

        @scoreText = @game.add.text(20, 12, "Score : " + @score, @scoreStyle)
        @scoreText.fixedToCamera = true #On le fixe à l'écran

    buildTimer: =>
        @timeContainer = @game.add.sprite(20, 70, "timeContainer") #On ajoute le conteneur de la timebar.
        @timeBar = @game.add.sprite(20, 70, "timeBar") #On ajoute le conteneur de la timebar.
        @timeBarWidth = @timeBar.width #On prend la taille initiale de la barre des temps
        #this.timeBar.width = 0;//On définit la barre des temps à 100% de sa taille
        @timeContainer.fixedToCamera = @timeBar.fixedToCamera = true #On les fixe à l'écran
        @timerLeft = @timerDuration #Le temps restant est égal au chrono de départ
        @timerText = @game.add.text(20, 40, "Chrono : " + @timerLeft + " s", @scoreStyle)
        @timerText.fixedToCamera = true #On le fixe à l'écran

    # SHOT - UPDATE FUNCTION
    collideTarget: =>
        if @gameover is false
            if @totalTargets > 0
                @game.physics.arcade.overlap @targetGroup, @shotExplosion, @targetShot, null, @ #La fonction targetShot(this.targetGroup,this.shotExplosion) sera executée lorsque une des cibles appartenant au targetGroup sera en collision avec une particule de shotExplosion...
            else
                @point = @score + @timerLeft
                @gameoverContain = "BRAVO \nTu as eu toutes les cibles.\n\nScore: " + @score + "\nDons un bonus temps: " + @timerLeft #On félicite le joueur et on lui attribue un bonus des secondes qu'il reste
                @gameOver() #On lance la fonction gameOver

    activeShot: =>
        @game.input.onDown.add @shotAction, @ #Active la fonction d'action de tir au clic
        @spacebar.onDown.add @shotAction, @ #Active la fonction d'action de tir lorsqu'on appuie sur la barre d'espace

    shotAction: =>
        if @gameover is false
            @shotgun.animations.play "shotAnim" #L'animation du fusil qui tire
            @shotExplosion.start true, 10, null, 1 #Les particules de shoot (type explosion ou non, durêe de vie en ms, frequence, quantité, forceQuantity)
            @shotSound = @game.add.audio("shot", 0.3) #On ajoute le son de shot avec 30% de volume
            @shotSound.play() #On le lance

    moveWorld: =>
        if @gameover is false
            if @cursors.left.isDown
                @game.camera.x -= @cursors.left.duration * 0.1 #On déplace la camera en fonction de la durée d'appui sur la touche, ce sera la même chose pour toutes les touches
            else @game.camera.x += @cursors.right.duration * 0.1  if @cursors.right.isDown
            if @cursors.up.isDown
                @game.camera.y -= @cursors.up.duration * 0.08
            else @game.camera.y += @cursors.down.duration * 0.08  if @cursors.down.isDown

#                    if @game.input.mouse.event.movementX?
#                        @movementX = @game.input.mouse.event.movementX if @game.input.mouse.event.movementX?
#                        @movementY = @game.input.mouse.event.movementY if @game.input.mouse.event.movementY?
#                        @game.camera.x += @movementX
#                        @game.camera.y += @movementY


    targetShot: (target, shot) =>
        target.kill() #Détruit la cible "t"
        @targetShotSound = @game.add.audio("break_target", 0.8) #On ajoute le son de la cible touchée à 80% de volume
        @targetShotSound.play() #On le lance
        @totalTargets-- #Réduit le nombre de cibles
        @score++ #Augmente le score
    #@scoreText.text = "Score : " + @score

    updateTimer: =>
        if @gameover is false
            if @timeBar.width > 0
                elapsedSeconds = (@timerDuration - @game.time.totalElapsedSeconds()) #Le décompte des secondes du timer
                @timerLeft = Math.round(elapsedSeconds)
                @timeBar.width = @timeBarWidth * elapsedSeconds / @timerDuration #Réduit la taille de la timeBar
                @timerText.text = "Chrono : " + @timerLeft + " s"
            else
                @point = @score - @totalTargets
                @gameoverContain = "L'entrainement est terminé \nTu n'as plus de temps \n\nScore: " + @score + "\n\n Dont un malus cible: -" + @totalTargets
                @gameOver()

    gameOver: =>
        #User.nextSequence()
        @gameover = true #On active la variable gameover qui empêche les actions du joueur
        #@game.destroy()
        @gameoverCurtain = @game.add.sprite(@game.camera.x, @game.camera.y, "curtain") #On ajoute un rideau masquant le jeu
        #                @gameoverStyle =
        #                    font: "35px Arial"
        #                    fill: "#fff"
        #                    stroke: "#6a9f3a"
        #                    strokeThickness: 1
        #                    align: "center"
        #                gameoverTextPositionX = @game.camera.x + (@game.width / 2) #Position du texte centré en x
        #                gameoverTextPositionY = @game.camera.y + (@game.height / 3) #Position du texte au tiers en y
        #                @gameoverText = @game.add.text(gameoverTextPositionX, gameoverTextPositionY, @gameoverContain, @gameoverStyle) #On place le texte en fonction du type de fin
        #                @gameoverText.anchor.set 0.5 #On centre le texte
        # On ajoute les points au niveau du jeu global
        @User.indicators.point += @point
        @Notification.error @gameoverContain
        #User.indicators.point += @point
        # On lance la sequence suivante puis on detruit le jeu au bout de 1,5s
        setTimeout ( =>
            @User.nextSequence()
        ), 1000

        setTimeout ( =>
            @game.destroy() if @game?
            @RemoveCanvas
        ), 4000

angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
