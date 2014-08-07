@DashboardApp.directive 'populationBrigade', ->
  link: (scope, el, attr) ->
    # link code begin
    margin =
      top: 5
      right: 10
      bottom: 5
      left: 10

    box =
      height: scope.height ||= 60
      width:  scope.width ||= 900
      inner_height: scope.height - margin.top - margin.bottom
      inner_width: scope.width - margin.right - margin.left

    svg = d3.select(el[0]).append('svg')
      .attr('width', box.width).attr('height', box.height).append('g')
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    # link code end
  restrict: "E"
  template: '<div></div>'
  scope:
    width:      '='
    height:     '='
    data:       '='
