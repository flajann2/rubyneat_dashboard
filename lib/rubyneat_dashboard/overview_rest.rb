require 'sinatra/base'

module Dashboard
  module Routing
    module REST
      module Overview
        def self.registered(app)
          app.get '/data/overview' do
            status 200
            {
              app:     'RubyNEAT Dashboard',
              project: '[[neater project name goes here]]',
              date:    Date.today(),
              version: SemVer.find.format("%M.%m.%p%s"),
            }.to_json
          end

          app.get '/data/status' do
            unless request.websocket?
              {
                  status: 'NIY'
              }.to_json
            else
              request.websocket do |ws|
                ws.onopen do
                  ws.send 'Status Socket Opened'
                  settings.sockets << ws
                end
                ws.onmessage do |msg|
                  EM.next_tick { settings.sockets.each{|s| s.send(msg)}}
                end
                ws.onclose do
                  warn('websocket is closed')
                  settings.sockets.delete(ws)
                end
              end
            end
          end
        end
      end
    end
  end
end
