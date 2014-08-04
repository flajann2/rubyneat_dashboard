@PopulationController = ($scope, populationService) ->
  $scope.init = ->
    $scope.entry = {}
    $scope.entries = []
    populationService.getMessages (message) ->
        $scope.$apply ->
          p = message.payload
          len = $scope.entries.length
          if (len > 0) && (p.generation < $scope.entries[len - 1].generation)
            $scope.entries = []

          $scope.entry = {
            generation: p.generation
            best: p.fitness.best
            best_name: p.fitness.best_name
            overall: p.fitness.overall
            worst: p.fitness.worst
            worst_name: p.fitness.worst_name
          }
          $scope.entries.push $scope.entry
