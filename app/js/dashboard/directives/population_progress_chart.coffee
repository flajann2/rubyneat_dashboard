@DashboardApp.directive 'populationProgressChart', ->
  link = (scope, el, attr) ->
    console.log('populationProgressChart' +
        ' width=' + scope.width +
        ' height=' + scope.height +
        ' data=' + scope.data)
    color = d3.scale.category10()
    data = scope.data
    width = scope.width || 500
    height = scope.height || 300
    el[0].innerHTML = ''
    graph = new Rickshaw.Graph(
      element: el[0]
      width: width
      height: height
      series: [
        data: data
        color: color
      ]
      renderer: scope.renderer
    )
    graph.render()
  link: link
  restrict: 'E'
  template: '<div></div>'
  scope:
    width:    '='
    height:   '='
    data:     '='
    renderer: '='
