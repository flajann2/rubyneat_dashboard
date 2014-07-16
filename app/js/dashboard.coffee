app = angular.module("Dashboard", [ 'ngResource',
                                    'ngRoute',
                                    'ngLocale',
                                    'ngSanitize',
                                    'btford.socket-io'])


app.factory "Dashboard", ($resource) ->
  $resource("/data/:id", {id: "@id"})

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

app.directive 'pie', ->
  link = (scope, el, attr) ->
    console.log('Pie Thrown ' + scope.data)
    color = d3.scale.category10()
    data = scope.data
    width = 300
    height = 300
    min = Math.min(width, height)
    svg = d3.select(el[0]).append('svg')
    pie = d3.layout.pie().sort(null)
    arc = d3.svg.arc()
      .outerRadius(min / 2 * 0.9)
      .innerRadius(min / 2 * 0.5)
    svg.attr(
      width: width
      height: height
    )
    g = svg.append('g')
      .attr('transform', "translate(#{width/2}, #{height/2}")
    arcs = g.selectAll('path').data(pie(data))
      .enter().append('path')
        .style('stroke', 'white')
        .attr('fill',
          (d,i) ->
            color(i)
        )
    scope.$watch('data',
      ->
        arcs.data(pie(data)).attr('d', arc)
      , true)
  link: link,
  restrict: 'E',
  scope:
    data: '='

