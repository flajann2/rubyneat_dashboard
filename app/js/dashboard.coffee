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
      templateUrl: "views/populations/home"
      controller: "PopulationController"
    ).when("/populations/general",
      templateUrl: "views/populations/general"
      controller: "PopulationController"
    ).when("/populations/speciation",
      templateUrl: "views/populations/speciation"
      controller: "PopulationController"
    ).when('/critters',
      templateUrl: 'views/critters'
      controller:  'CrittersController'
    ).otherwise redirectTo: "/"
  ]

app.directive 'pie', ->
  link = ($scope, element, attr) ->
    alert 'Pie Thrown'
  { link: link,  restrict: 'E' }

@DashboardController = ($scope) ->

@OverviewController = ($scope) ->

@PopulationController = ($scope) ->

@HomeController = ($scope) ->
