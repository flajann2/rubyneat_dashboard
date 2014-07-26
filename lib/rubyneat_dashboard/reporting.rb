=begin rdoc
=Dashboard Reporting
The Dashboard will need to report on the activities of the progress of evolution
and the functional aspects of the Critters, etc. And thusly we define all this
here.

=end

require_relative 'main'

module Dashboard
  class << self
    # Main reporting module. Create something that is easily JSONable to
    # represent the ongoing state of affairs to the dashboard.
    def report_on(population, report)
      report
    end
  end
end
