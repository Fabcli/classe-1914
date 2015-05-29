angular.module('classe1914.game').factory 'LoadGameConstant', [
    'Story'
    'User'
    'constant.games.shot.demo'
    'constant.games.interactive.train'
    (Story, User, demoShot, trainInteractive)->
        new class LoadGameConstant
            constructor: () ->

            loadAssets: ->
                @ASSETS = null

                @sequence = Story.sequence(User.chapter, User.scene, User.sequence)
                @gameModel  = @sequence.game_model
                @gameName   = @sequence.game_name

                if @gameModel is 'shot'
                    @ASSETS = demoShot.assets if @gameName is 'demo'
                if @gameModel is 'interactive'
                    @ASSETS = trainInteractive.assets if @gameName is 'train'
                console.log @ASSETS
                @ASSETS

]