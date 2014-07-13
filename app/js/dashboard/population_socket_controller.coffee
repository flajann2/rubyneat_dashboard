@PopulationSocketController = (PopulationSocket) ->
  PopulationSocket.on('pop-update',
  ->
    $scope.update = true
  )
