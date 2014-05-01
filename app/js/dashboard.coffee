app = angular.module("Dashboard", ['ngResource', 'ngRoute'])

app.factory "Dashboard", ($resource) ->
  $resource("/data/:id", {id: "@id"}
  )

app.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when('/',
      templateUrl: 'views/home'
      controller:  'HomeController'
    ).when('/overview',
      templateUrl: 'views/overview'
      controller:  'OverviewController'
    ).when("/populations",
      templateUrl: "views/populations"
      controller: "PopulationController"
      resolve:
        user: (SessionService) ->
          SessionService.getCurrentUser()
    ).otherwise redirectTo: "/"

]

$DashboardController = ($scope) ->
