class WelcomeCtrl
    @$inject: ['$scope', 'User', '$timeout']
    constructor: (@scope, @User, @timeout, @Shot) ->
        @scope.user  = @User
        @scope.email = @User.email
        # Takes the chapter only when the controller is instantiated
        @token       = @User.token
        # Guide visible steps
        @scope.showHeadphone = @scope.showControl = no
        # Animate the wrapper
        @scope.wrapperUp = no
        # Delay between each step of the guide
        @guideStepDelay = 2000


        @scope.submit = =>
            # Saves the email
            @User.email  = @scope.email
            # And starts the game!
            @User.inGame = yes

        # True if the user is a new one
        @scope.isNewUser = =>
            not @token?

        # True if the user didn't choose a hero
        @scope.textIntro = =>
            text_intro = no
            if @User.hero is null
                text_intro = yes
            text_intro

        # Start the game by activating the using
        @scope.startGame = (guide=yes)=>
            # Animate the welcome wrapper
            @scope.wrapperUp = yes
            return @User.inGame = yes unless guide
            # Show headphone guide's step
            @scope.showHeadphone = yes
            # Delay second step
            @timeout =>
                # Show control guide's step
                @scope.showControl  = yes
                # Delay launching
                @timeout (=> @User.inGame = yes), @guideStepDelay
                # Reset value after a short delay
                @timeout (=> @scope.showHeadphone = @scope.showControl = no), @guideStepDelay * 2
                , @guideStepDelay

        # Start a new party
        @scope.newGame = =>
            # Animate the welcome wrapper
            @scope.wrapperUp = yes
            # Creates a new user
            do @User.newUser
            # And starts the game!
            @User.inGame = yes

        @scope.shouldShowWelcome = =>
            not @User.inGame and not @User.isGameDone

        # To launch the gameCtrl in the element <game>
        @scope.gameReady = =>
            true


angular.module('classe1914').controller("WelcomeCtrl", WelcomeCtrl)
# EOF