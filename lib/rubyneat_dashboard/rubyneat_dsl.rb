=begin rdoc
= Dashboard DSL for RubyNEAT
Additions to the RubyNEAT DSL for hooking into the Dashboard.
=end
require 'pp'

module NEAT
  module DSL
    def dashboard(&block)
      Dashboard::run_dashboard!
      block.() if block_given?
      NEAT::controller.pre_exit_add do
        puts "Dashboard waiting for user to exit. Or you may do a ^C."
        Dashboard::join!
        puts "Dashboard exited."
      end

      NEAT::controller.end_run_add  do |c|
        puts 'Dashboard end_run called.'
      end
    end
  end
end
