@PopulationController = ($scope, populationService) ->
  $scope.init = ->
    $scope.entries = 'Nothing yet'
    populationService.getMessages (message) ->
        $scope.$apply ->
          $scope.entries = message
