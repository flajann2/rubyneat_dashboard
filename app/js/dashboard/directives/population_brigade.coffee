@DashboardApp.directive 'populationBrigade', ->
  link: (scope, el, attr) ->
    # link code begin
    margin =
      top:     5
      right:  10
      bottom:  5
      left:   10

    box =
      height:       h = scope.height || 160
      width:        w = scope.width || 900
      inner_height: h - margin.top - margin.bottom
      inner_width:  w - margin.right - margin.left


    config =
      numOfPops:    scope.numberOfPops || 10
      tranDuration: 200
      tranDelay:    200

    icon =
      uri:    "/images/population_sprite.050.png"
      width:  50
      height: 148
      bottom: 10

    range =
      x: d3.scale.linear().range([ box.width + icon.width, -icon.width]).domain([0, config.numOfPops])
      y: d3.scale.linear().range([ box.height, 0 ])

    svg = d3.select(el[0]).append('svg:svg')
      .attr('width', box.width).attr('height', box.height)
      .append('g')
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    data = []

    popbox_update = (tick) ->
      data.unshift tick
      data.pop() if data.length > config.numOfPops

      g = svg.selectAll("g").data(data, (d) ->
          d.generation
        )

      g.exit().transition().duration(config.tranDuration).delay(config.tranDelay).remove()

      gupdate = g.transition().duration(config.tranDuration).delay(config.tranDelay)
        .attr("transform", (d, i) ->
          "translate(#{range.x(i)}, #{0})"
        )

      genter = g.enter().append("g")
        .attr("transform", (d, i) ->
          "translate(#{range.x(i)}, #{0})"
        )

      genter.append("image")
        .attr("xlink:href", icon.uri)
        .attr("width", icon.width)
        .attr("height", icon.height)

      genter.append("text").text( (d)->
          "Gen# #{d.generation}"
          ).attr("transform",
            "translate(#{icon.width / 2}, #{icon.height - icon.bottom}) rotate(-90)"
          )


    update_brigade = (tick) ->
      popbox_update tick

    scope.$watch 'tickSource', (tick) ->
      update_brigade tick

    # link code end
  restrict: "E"
  scope:
    width:         '='
    height:        '='
    tickSource:    '='
    numberOfPops:  '='
