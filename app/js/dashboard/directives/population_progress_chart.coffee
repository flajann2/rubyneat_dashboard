@DashboardApp.directive 'population-progress-chart', ->
  link = (scope, element, attr) ->
    # put D3 code here
    console.log('population-progress-chart' +
      ' width=' + scope.width +
      ' height=' + scope.height
    )
    color = d3.scale.category10()
    data = scope.data
    width = scope.width || 500
    height = scope.height || 300

  link: link
  restrict: "E"
  scope:
    width: '='
    height: '='
