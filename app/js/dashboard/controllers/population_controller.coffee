@PopulationController = ($scope) ->
  $scope.init = ->
    $scope.entries = 'Nothing yet'
    source = new EventSource('/population')
    source.onmessage = (event) ->
      $scope.$apply ->
        $scope.entries = JSON.parse(event.data)
