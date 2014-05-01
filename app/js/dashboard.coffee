app = angular.module("Dashboard", ['ngResource'])

app.factory "Dashboard", ($resource) ->
  $resource("/data/:id", {id: "@id"}
  )

$DashboardController = ($scope) ->
