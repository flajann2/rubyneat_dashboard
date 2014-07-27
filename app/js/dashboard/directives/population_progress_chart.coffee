@DashboardApp.directive 'populationProgressChart', ->
  link = (scope, el, attr) ->
    console.log('populationProgressChart' +
        ' width=' + scope.width +
        ' height=' + scope.height +
        ' data=' + scope.data)
    color  = scope.color || d3.scale.category10()
    data   = scope.data
    width  = scope.width || 500
    height = scope.height || 300
    labels = scope.labels || ['alpha']
    svg = d3.select(el[0]).append('svg')

    margin =
      top: 20
      right: 80
      bottom: 30
      left: 50

    width  -= margin.left + margin.right
    height -= margin.top + margin.bottom
    svg.attr(
      width: width
      height: height
    )

    x = d3.scale.linear().range([ 0, width ])
    y = d3.scale.linear().range([ height, 0 ])
    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")
    line = d3.svg.line().interpolate("basis").x((d) ->
      x d.gen
    ).y((d) ->
      y d.best
    )
    datamessage = (data) ->
      color.domain d3.keys(data[0]).filter((key) ->
        key isnt "gen"
      )

      fitness = color.domain().map((name) ->
        name: name
        values: data.map((d) ->
          gen: d.gen
          fitness: +d[name]
        )
      )
      x.domain d3.extent(data, (d) ->
        d.gen
      )
      y.domain [ d3.min(labels, (c) ->
        d3.min c, (v) ->
          v.fitness

      ), d3.max(fitness, (c) ->
        d3.max c.values, (v) ->
          v.fitness

      ) ]
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
      svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Fitness"
      fit = svg.data(fitness).enter().append("g").attr("class", "fit")
      fit.append("path").attr("class", "line").attr("d", (d) ->
        line d.values
      ).style "stroke", (d) ->
        color d.name

      fit.append("text").datum((d) ->
        name: d.name
        value: d.values[d.values.length - 1]
      ).attr("transform", (d) ->
        "translate(" + x(d.value.date) + "," + y(d.value.temperature) + ")"
      ).attr("x", 3).attr("dy", ".35em").text (d) ->
        d.name
    datamessage(data)

  link: link
  restrict: 'E'
  template: '<div></div>'
  scope:
    width:    '='
    height:   '='
    data:     '='
    color:    '='
    labels:   '='
