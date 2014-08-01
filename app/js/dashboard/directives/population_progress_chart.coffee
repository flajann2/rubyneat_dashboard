@DashboardApp.directive 'populationProgressChart', ->
  link = (scope, el, attr) ->
    color  = scope.color || d3.scale.category10()
    width  = scope.width || 500
    height = scope.height || 300
    labels = scope.labels || ['alpha']
    basis  = scope.basis || 'generation'
    xname = scope.xAxisName || '*Generations*'
    yname = scope.yAxisName || '*Fitness*'

    margin =
      top: 20
      right: 80
      bottom: 30
      left: 50

    svg = d3.select(el[0]).append('svg')
      .attr('width', width).attr('height', height).append('g')
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    width  -= margin.left + margin.right
    height -= margin.top + margin.bottom

    svg.append("defs").append("clipPath")
      .attr("id", "clip")
      .append("rect")
      .attr("width", width)
      .attr("height", height);

    datamessage = (data) ->
      x = d3.scale.linear().range([ 0, width ])
      y = d3.scale.linear().range([ height, 0 ])

      xAxis = d3.svg.axis().scale(x).orient("bottom")
      yAxis = d3.svg.axis().scale(y).orient("left")

      line = d3.svg.line().interpolate("linear").x((d) ->
        x d.gen
      ).y((d) ->
        y d.fitness
      )

      color.domain labels
      gxAxix = svg.append("g").attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
      gyAxis = svg.append("g").attr("class", "y axis")

      update_fitness = ->
        color.domain().map (name) ->
          name: name
          values: data.map (d) ->
            gen: d[basis]
            fitness: +d[name]

      update_domains = (fitness) ->
        x.domain d3.extent data, (d) ->
          d[basis]

        y.domain [ d3.min(fitness, (c) ->
          d3.min c.values, (v) ->
            v.fitness
        ), d3.max(fitness, (c) ->
          d3.max c.values, (v) ->
            v.fitness
        ) ]

      update_axes = ->
        gxAxix.call(xAxis)
        .append("text").attr("transform", "translate(" + width / 2 + "," + 30 + ")")
        .attr("x", 6).attr("dx", ".9em")
        .style("text-anchor", "end").text xname

        gyAxis.call(yAxis)
        .append("text").attr("transform", "rotate(-90)")
        .attr("y", 6).attr("dy", ".9em")
        .style("text-anchor", "end").text yname

      render = (data) ->
        fitness = update_fitness()
        update_domains(fitness)
        update_axes()

        scope.paths = svg.selectAll(".fit")
          .data(fitness)
          .enter().append("g").attr("class", "fit")

        scope.paths.append("path").attr("class", "line")
          .attr("d", (d) ->
              line d.values
            ).style "stroke", (d) ->
              color d.name

        scope.paths.append("text")
          .datum((d) ->
              name: d.name
              value: d.values[d.values.length - 1]
            )
          .attr("transform", (d) ->
              "translate(" + x(d.value.gen) + "," + y(d.value.fitness) + ")"
            ).attr("x", 3).attr("dy", ".35em")
          .text (d) ->
            d.name

      render(data)

      render_tick = (tick) ->
        fitness = update_fitness()
        update_domains(fitness)
        update_axes()

      scope.$watch 'tickSource', (tick) ->
        render_tick(tick)
      , true

    datamessage scope.data

  link: link
  restrict: 'E'
  template: '<div></div>'
  scope:
    width:      '='
    height:     '='
    data:       '='
    tickSource: '='
    color:      '='
    labels:     '='
    basis:      '='
    xAxisName:  '@'
    yAxisName:  '@'
