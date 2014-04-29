app = angular.module("Dashboard", ['ngResource'])

# Alternate way to bootstrap Angluar in a Turbolinks-friendy manner.
#$(document).on('ready page:load', ->
#  angular.bootstrap(document, ['RubyNEATWiki'])
#)

app.factory "Dashboard", ($resource) ->
  $resource("/data/:id", {id: "@id"}
  )
