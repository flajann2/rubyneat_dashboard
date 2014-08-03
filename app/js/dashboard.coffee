@DashboardApp = angular.module("Dashboard", [ 'ngResource',
                                              'ngRoute',
                                              'ngLocale',
                                              'ngSanitize',
                                              'btford.socket-io'])


@DashboardApp.factory "Dashboard", ($resource) ->
  $resource("/data/:id", {id: "@id"})

@DashboardApp.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider
    .when('/',
      templateUrl: 'views/home'
      controller:  'HomeController'
    ).when('/overview',
      templateUrl: 'views/overview'
      controller:  'OverviewController'
    ).when("/population",
      templateUrl: "views/population/home"
      controller: "PopulationController"
    ).when("/population/general",
      templateUrl: "views/population/general"
      controller: "PopulationController"
    ).when("/population/speciation",
      templateUrl: "views/population/speciation"
      controller: "PopulationController"
    ).when('/critters',
      templateUrl: 'views/critters'
      controller:  'CrittersController'
    ).otherwise redirectTo: "/"
  ]

Array::toDict = (key) ->
  @reduce ( (dict, obj) ->
      dict[ obj[key] ] = obj if obj[key]?
      dict
    ), {}
