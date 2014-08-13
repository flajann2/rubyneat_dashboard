=begin rdoc
= Dashboard DSL for RubyNEAT
Additions to the RubyNEAT DSL for hooking into the Dashboard.
=end
require 'pp'

module NEAT
  class DashboardQueues < NeatOb
    attr_neat :population, queue: true
    attr_neat :report,     queue: true
    def initialize
      super(NEAT::controller)
    end

    def each_setting
      controller.parms.instance_variables.each { |name|
        yield name, controller.parms.instance_variable_get(name)
      }
    end
  end

  module DSL
    def dashboard(&block)
      Dashboard::dq ||= DashboardQueues.new

      #FIXME: this is set too late in the game.
      def port(portnum)
        Dashboard::opts.port = portnum
      end

      #FIXME: this is set too late in the game.
      def bind(bindaddr)
        Dashboard::opts.bindaddr = bindaddr
      end

      block.() if block_given?
      Dashboard::run_dashboard!

      NEAT::controller.pre_exit_add do
        puts "Dashboard waiting for user to exit. Or you may do a ^C."
        Dashboard::join!
        puts "Dashboard exited."
      end

      NEAT::controller.end_run_add  do |c|
        puts 'Dashboard end_run called.'
      end

      NEAT::controller.report_add do |pop, rept|
        Dashboard.dq.population << Dashboard.report_on(pop, rept)
      end
    end
  end
end
