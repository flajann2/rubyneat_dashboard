object @pop => :population
attributes :generation, :name
child(critters: :critters) { |crit|
  attributes :name, :fitness, :novelty
}
