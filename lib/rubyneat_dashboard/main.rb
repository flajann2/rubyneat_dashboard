=begin rdoc
Main file to pull in all other modules
=end

require 'semver'
require 'eventmachine'
require_relative 'bower_dsl'
require_relative 'overview_rest'
require_relative 'rubyneat_dsl'
require_relative 'stream_helpers'

include StreamHelpers

module Dashboard
  class << self
    def dq=(dashboard_queues)
      @dq = dashboard_queues
    end

    def dq
      @dq
    end
  end

  module Routing
    module Main

      class << self
        def registered(app)
          app.get '/' do
            haml :layout
          end

          app.get '/views/*' do |view|
            haml view.to_sym, layout: false
          end

          # streaming population data
          list = []
          app.get '/population', provides: 'text/event-stream' do
            stream(:keep_open) do |out|
              loop {
                payload = wrap_for_sending payload: Dashboard.dq.population.pop
                puts payload
                out << payload
              }
              list << out
              puts list.count
              out.callback {
                puts 'closed'
                list.delete(out)
              }
              out.errback {
                $log.warn "population stream lost connection"
                list.delete out
              }
            end
          end
        end
      end
    end
  end
end
