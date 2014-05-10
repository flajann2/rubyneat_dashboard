require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra-websocket'
require 'barista'
require 'sass'
require 'haml'

require_relative 'rubyneat_dashboard/main'

module Dashboard
  class RubyneatDashboard < Sinatra::Base
    set :root, File.expand_path('..', File.dirname(__FILE__))
    set :logging, true
    set :server, 'thin'
    set :sockets, []

    register Barista::Integration::Sinatra
    register Sinatra::AssetPack
    register Routing::Main
    register Routing::REST::Overview

    assets do
      serve '/js',      from: 'app/js'           # Default
      serve '/css',     from: 'app/css'          # Default
      serve '/images',  from: 'app/images'       # Default
      serve '/bower',   from: 'bower_components' # Default


      # The second parameter defines where the compressed version will be served.
      # (Note: that parameter is optional, AssetPack will figure it out.)
      js :app, '/js/app.js',
          [
            # '/js/jquery-2.1.0.js',
            '/bower/jquery/dist/jquery.js',
            '/js/angular.js',
            '/js/angular/**/*.js',
            '/js/dashboard.js',
            '/js/dashboard/*.js',
            '/js/foundation.min.js',
           # '/js/foundation/*.js',
            '/js/vendor/**/*.js',
          ]

      css :application, '/css/application.css',
          [
            '/css/foundation.css',
           # '/css/vendor/*.css',
           # '/css/dashboard.css',
           # '/css/dashboard/*.css'
          ]

      #js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
      css_compression :simple   # :simple | :sass | :yui | :sqwish
    end

    configure do
      set port: 3912
      set static: true
    end
  end
end

Dashboard::RubyneatDashboard.run!
