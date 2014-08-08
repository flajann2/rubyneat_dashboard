@DashboardApp.factory 'populationService', () ->
  source = new EventSource('/population')
  receivers = []
  getMessages: (receiver) ->
    receivers.push receiver
    source.onmessage = (event) ->
      receivers.forEach (receiver) ->
        receiver(JSON.parse(event.data))

@DashboardApp.factory 'populationHistoryService', (populationService) ->
  history = []
  populationService.getMessages (message) ->
    history.push message

  getMessages: (receiver) ->
      history.forEach (message) ->
        receiver(message)
      populationService.getMessages (message) ->
        receiver(message)

