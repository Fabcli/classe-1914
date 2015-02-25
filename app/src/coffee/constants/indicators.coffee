angular.module('classe1914.constant').constant 'constant.indicators',
  meta:
      rules:
          lessThanOrEqual: 'lte'
          lessThan: 'lt'
          greaterThanOrEqual: 'gte'
          greaterThan: 'gt'

  all:
      luck:
          start: 50
          max:  100
          min:  0
#          gameOver:
#              on:   'min'
#              rule: 'lte'

      health:
          start: 100
          min: 0
          max: 100
#          gameOver:
#              on:   'min'
#              rule: 'lte'

      mood:
          min: 0
          max: 100
          start: 50
#          gameOver:
#              on:   'min'
#              rule: 'lte'


