@PopulationController = ($scope, $timeout, populationHistoryService) ->
  $scope.init = ->
    $scope.entry = {}
    populationHistoryService.getMessages (message) ->
        $timeout ->
          p = message.payload

          $scope.entry = {
            generation: p.generation
            best: p.fitness.best
            best_name: p.fitness.best_name
            overall: p.fitness.overall
            worst: p.fitness.worst
            worst_name: p.fitness.worst_name
          }
        , 0, true
