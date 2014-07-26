# This is a test for D3, which we may actually use later.
# The pie is really a doughnut chart. Pie is shorter to type. Haha.
@DashboardApp.directive 'pie', ->
  link = (scope, el, attr) ->
    console.log('Pie data=' + scope.data +
      ' width=' + scope.width +
      ' height=' + scope.height)
    color = d3.scale.category10()
    data = scope.data
    width = scope.width || 300
    height = scope.height || 300
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
    g = svg.append('g').attr('transform', "translate(#{width/2}, #{height/2})")
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
  link: link
  restrict: 'E'
  scope:
    data:   '='
    width:  '='
    height: '='
