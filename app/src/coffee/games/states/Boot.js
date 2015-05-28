// Generated by CoffeeScript 1.8.0
(function() {
  angular.module('classe1914.game').factory('Boot', [
    'constant.games.preload', '$filter', function(preloadAssets, $filter) {
      var Boot;
      return new (Boot = (function() {
        function Boot() {}

        Boot.prototype.init = function() {
          this.input.maxPointers = 1;
          this.stage.disableVisibilityChange = true;
          if (this.game.device.desktop) {
            this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
            this.scale.setMinMax(1024, 768, 1920, 1200);
            this.scale.forceLandscape = true;
            this.scale.pageAlignHorizontally = true;
            this.scale.setScreenSize(true);
            return this.scale.refresh();
          } else {
            this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
            this.scale.setMinMax(480, 260, 1024, 768);
            this.scale.forceLandscape = true;
            this.scale.pageAlignHorizontally = true;
            this.scale.setScreenSize(true);
            return this.scale.refresh();
          }
        };

        Boot.prototype.preload = function() {
          this.load.image('preloadBar', $filter('media')(preloadAssets.bar));
          return this.load.image('preloadBarContainer', $filter('media')(preloadAssets.barContainer));
        };

        Boot.prototype.create = function() {
          return this.state.start('Preloader');
        };

        return Boot;

      })());
    }
  ]);

}).call(this);

//# sourceMappingURL=Boot.js.map