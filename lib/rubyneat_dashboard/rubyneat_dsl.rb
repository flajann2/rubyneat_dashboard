=begin rdoc
= Dashboard DSL for RubyNEAT
Additions to the RubyNEAT DSL for hooking into the Dashboard.
=end

module NEAT
  module DSL
    def dashboard(&block)
      Dashboard::run_dashboard!
      block.() if block_given?
      NEAT::controller.pre_exit_func = Proc.new {
        puts "Dashboard waiting for user to exit. Or you may do a ^C."
        Dashboard::join!
        puts "Dashboard exited."
      }
    end
  end
end
