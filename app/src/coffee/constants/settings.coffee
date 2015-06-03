angular.module('classe1914.constant').constant 'constant.settings',
  # URL where to find the media
  # (Append using "media" filter )
  mediaUrl          : window.MEDIA_URL or ""

# Animations
  chapterEntrance     : 3*1000
  sceneEntrance       : 1*1000
  caseEntrance        : 500
  archiveNotification : 1*1000
  feedbackDuration    : 2*1000
# Some types of sequence have different behavior
  sequenceWithNext  : ["dialog", "narrative", "notification", "voixoff", "video_background"]
  sequenceDialog    : ["dialog", "narrative"]
  sequenceSkip      : ["new_background"]
# Refreshing rate for timeouts
  timeoutRefRate    : 100
# Default value for delay in second on active autoplay
  defaultDelay      : 6
# Active the pause on videoBackground when the user open the case
  activeBgPause     : true

