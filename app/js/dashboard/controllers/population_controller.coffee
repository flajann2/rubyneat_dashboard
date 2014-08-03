@PopulationController = ($scope, populationService) ->
  $scope.init = ->
    $scope.entry = {}
    $scope.entries = []
    populationService.getMessages (message) ->
        $scope.$apply ->
          p = message.payload
          $scope.entry = {
            generation: p.generation
            best: p.fitness.best
            overall: p.fitness.overall
            worst: p.fitness.worst
          }
          $scope.entries.push $scope.entry
