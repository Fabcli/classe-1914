class NavCtrl
    @$inject: ['$scope', 'User', 'Fullscreen']
    constructor: (@scope, @User, @Fullscreen) ->
        @scope.user       = @User
        @scope.volume     = @User.volume * 100
        @scope.volumeBp   = if @scope.volume is 0 then 100 else @scope.volume
        # True if the volume is on
        @scope.isVolumeOn = => @User.volume > 0

        @scope.autoplay = @User.autoplay

        @scope.isAutoplayOn = => @User.autoplay

        # Autoplay value
        @scope.toggleAutoplay = =>
            @User.autoplay = !@User.autoplay
            @scope.autoplay = !@scope.autoplay

        # Mute or unmute the volume
        @scope.toggleVolume = =>
            if @User.volume is 0
                # Restore old volume value
                @scope.volume = @scope.volumeBp
                # Update the user's volume
                @User.volume = @scope.volume/100
            else
                # Save old volume value
                @scope.volumeBp = @scope.volume
                # Update the user's volume
                @User.volume = @scope.volume = 0

        @scope.toggleFullscreen = =>
            if Fullscreen.isEnabled()
                Fullscreen.cancel()
            else
                Fullscreen.all()

        @scope.isFullscreen = =>
            Fullscreen.isEnabled()

        # Update the User volume according the scope attribute
        @scope.$watch "volume", (v)=> @User.volume = v/100 if v?

        # Update the User autoplay value
        @scope.$watch "autoplay", (a)=> @User.autoplay = a if a?

        @scope.shouldShowSaveButton = @shouldShowSaveButton
        @scope.save = @save

        @_shouldShowSaveButton = yes
        @scope.shouldShowSubmitButton = yes

        @scope.$watch =>
            User.inGame
        , (newValue, oldValue) =>
            if @User.email? and newValue and not oldValue
               @_shouldShowSaveButton = false

        @scope.$watch 'shouldShowSaveForm', (newValue, oldValue) =>
            if @User.email? and oldValue and not newValue
               @_shouldShowSaveButton = false

    shouldShowSaveButton: =>
       return @User.inGame && @_shouldShowSaveButton

    save: =>
        email = @scope.email
        @scope.shouldShowSubmitButton = no
        (@User.associate email)
        .success =>
            @User.email = email
        .error =>
            @scope.shouldShowSubmitButton = yes
            return

angular.module('classe1914').controller("NavCtrl", NavCtrl)
# EOF
