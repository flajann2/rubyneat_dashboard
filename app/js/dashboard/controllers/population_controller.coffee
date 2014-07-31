@PopulationController = ($scope, populationService) ->
  $scope.init = ->
    $scope.entry = {}
    $scope.entries = [
      {generation: 1, best: 1.0, overall: 0.5, worst: 0.0},
      {generation: 2, best: 2.0, overall: 0.6, worst: 0.5},
      {generation: 3, best: 3.0, overall: 1.0, worst: 0.5},
      {generation: 4, best: 3.0, overall: 2.5, worst: 1.0},
      {generation: 5, best: 4.0, overall: 2.5, worst: 1.0},
      {generation: 6, best: 4.0, overall: 2.5, worst: 1.5}
    ]
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
