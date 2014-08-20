@DashboardApp.directive 'populationWindow', (populationDrilldownService) ->
  link: (scope, el, attr) ->
    # code begin
    margin =
      top:     5
      right:  10
      bottom:  5
      left:   10

    box =
      height:       h = scope.height || 200
      width:        w = scope.width || 900
      inner_height: h - margin.top - margin.bottom
      inner_width:  w - margin.right - margin.left

    populationDrilldownService
      .getPopulation(genNum: 0
        , (resp) ->
          scope.pop = resp.data.population
        , (resp) ->
          scope.error = resp
      )

    svg = d3.select(el[0]).append('svg:svg')
      .attr('width', box.width).attr('height', box.height)
      .append('g')
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    # code end
  restrict: "E"
  scope:
    width:         '='
    height:        '='
    popSource:     '='
