@PopulationController = ($scope, populationService) ->
  $scope.init = ->
    $scope.entries = 'Nothing yet'
    #$scope.color = d3.color.category10()
    populationService.getMessages (message) ->
        $scope.$apply ->
          $scope.entries = message

