=begin rdoc
Main file to pull in all other modules
=end

require 'json'
require 'json/stream'
require 'semver'
require 'eventmachine'
require_relative 'bower_dsl'
require_relative 'overview_rest'
require_relative 'rubyneat_dsl'

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
      def self.registered(app)
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
            EventMachine::PeriodicTimer.new(1) {
              j = JSON( { event: 'message',
                          time: Time.now })
              payload = "event:message\ndata: #{j}\n\n"
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
