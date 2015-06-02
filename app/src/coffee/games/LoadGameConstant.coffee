angular.module('classe1914.game').factory 'LoadGameConstant', [
    'constant.games.shot.demo'
    'constant.games.interactive.train'
    (demoShot, trainInteractive)->
        new class LoadGameConstant
            constructor: () ->

            loadAssets: (gameModel, gameName) =>
                @ASSETS = null

                if gameModel is 'shot'
                    if gameName is 'demo'
                        @ASSETS = demoShot.assets
                if gameModel is 'interactive'
                    if gameName is 'train'
                        @ASSETS = trainInteractive.assets
                @ASSETS

            loadSettings: (gameModel, gameName) =>
                @SETTINGS = null

                if gameModel is 'shot'
                    if gameName is 'demo'
                        @SETTINGS = demoShot.settings
                if gameModel is 'interactive'
                    if gameName is 'train'
                        @ASSETS = trainInteractive.assets
                @SETTINGS
]