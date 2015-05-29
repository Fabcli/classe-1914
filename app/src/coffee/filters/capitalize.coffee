# @source https://gist.github.com/paulakreuger/b2af1958f3d67f46447e

angular.module("classe1914.filter").filter "capitalize", ->
    (input, scope) ->
        input = input.toLowerCase()  if input?
        input.substring(0, 1).toUpperCase() + input.substring(1)