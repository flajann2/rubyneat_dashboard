=begin rdoc
Main file to pull in all other modules
=end

require 'semver'
require 'eventmachine'
require 'queue_ding'
require_relative 'bower_dsl'
require_relative 'overview_rest'
require_relative 'rubyneat_dsl'
require_relative 'rubyneat_api'
require_relative 'stream_helpers'
require_relative 'reporting'

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

          app.get '/json/*' do |path|
            @params = params
            @con = NEAT::controller
            @pop = @con.population_complete(params['gen'].nil? ? nil : params['gen'].to_i)
            rabl "/json/#{path}".to_sym, format: 'json'
          end

          # streaming population data
          list = []
          app.get '/population', provides: 'text/event-stream' do
            stream(:keep_open) do |out|
              Thread.new do
                loop {
                  payload = wrap_for_sending payload: Dashboard.dq.population.next
                  out << payload
                }
              end
              
              list << out
              $log.debug "list count #{list.count}"
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
