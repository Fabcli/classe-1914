# @source http://stackoverflow.com/questions/18095727/limit-the-length-of-a-string-with-angularjs
#   OPTIONS :
#   -> wordwise (boolean) - if true, cut only by words bounds,
#   -> max (integer) - max length of the text, cut to this number of chars,
#   -> tail (string, default: ' …') - add this string to the input string if the string was cut.

angular.module("classe1914.filter").filter "excerpt", ->
    (value, wordwise, max, tail) ->
        return ""  unless value
        max = parseInt(max, 10)
        return value unless max
        return value if value.length <= max
        value = value.substr(0, max)
        if wordwise
            lastspace = value.lastIndexOf(" ")
            value = value.substr(0, lastspace) unless lastspace is -1
        value + (tail or " …")