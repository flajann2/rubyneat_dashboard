@DashboardApp.factory 'populationDrilldownService', ($http) ->
  getPopulation: (p, functSuccess, functFailure) ->
    $http(
      method: 'GET'
      url: "/json/population?gen=#{p.genNum}")
        .then functSuccess, functFailure

  getCritterGenotype: (p, functSuccess, functFailure) ->
    $http(
      method: 'GET'
      url: "/json/population/critter/genotype?gen=#{p.genNum}&crit=#{p.critName}")
        .then functSuccess, functFailure

  getCritterPhenotype: (critName, functSuccess, functFailure) ->
    $http(
      method: 'GET'
      url: "/json/population/critter/phenotype?gen=#{p.genNum}&crit=#{p.critName}")
        .then functSuccess, functFailure
