angular.module('classe1914.constant').constant 'constant.settings',
  # URL where to find the media
  # (Append using "media" filter )
  mediaUrl          : window.MEDIA_URL or ""

# Animations
  chapterEntrance   : 3*1000
  sceneEntrance     : 1*1000
  feedbackDuration  : 2*1000
# Some types of sequence have different behavior
  sequenceWithNext  : ["dialogue", "narrative", "notification", "voixoff"]
  sequenceDialog    : ["dialogue", "narrative"]
  sequenceSkip      : ["new_background"]
# Refreshing rate for timeouts
  timeoutRefRate    : 100
# Some scenes affect the percentage of progression
  mainScenes        :
    "1": ["1.1", "1.5", "1.8"]

