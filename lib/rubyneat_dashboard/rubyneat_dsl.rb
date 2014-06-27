=begin rdoc
= Dashboard DSL for RubyNEAT
Additions to the RubyNEAT DSL for hooking into the Dashboard.
=end

module NEAT
  module DSL
    def dashboard(&block)
      Dashboard::run_dashboard!
      block.() if block_given?
      at_exit { Dashboard::join! }
    end
  end
end
