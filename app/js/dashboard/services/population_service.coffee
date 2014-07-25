@DashboardApp.factory 'populationService', () ->
  source = new EventSource('/population')
  getMessages: (receiver) ->
    source.onmessage = (event) ->
        receiver(JSON.parse(event.data))
