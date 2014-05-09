=begin rdoc
Main file to pull in all other modules
=end

require_relative 'overview_rest'

module Dashboard
  module Routing
    module Main
      def self.registered(app)
        app.get '/data/' do
        end

        app.get '/' do
          haml :layout
        end

        app.get '/views/*' do |view|
          haml view.to_sym, layout: false
        end
      end
    end
  end
end