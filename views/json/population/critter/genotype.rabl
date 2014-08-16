crit = @pop[@params['crit']]
object crit => :genotype
attributes :name, :fitness, :novelty
child(crit.genotype.genes.values => :genes){ |g|
  attributes :innovation, :in_neuron, :out_neuron, :weight, :enabled
}
child(crit.genotype.neurons.values => :neurons){ |neu|
  attributes :name, :heirarchy_number, :output, :class
}