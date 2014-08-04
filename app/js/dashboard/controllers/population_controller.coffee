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
            overall: p.fitness.overall
            worst: p.fitness.worst
          }
          $scope.entries.push $scope.entry
