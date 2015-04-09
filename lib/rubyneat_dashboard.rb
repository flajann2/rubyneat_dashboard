require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/streaming'
require 'barista'
require 'sass'
require 'haml'
require 'rabl'
require 'logger'
require 'sinatra/contrib/all'
require_relative 'rubyneat_dashboard/main'

Logger.class_eval { alias :write :'<<' }

module Dashboard
  class DashboardException < Exception; end

  class DashOpts < NEAT::NeatOb
    def initialize
      super controllerfrei: true
    end

    attr_neat :port, default: 3912
    attr_neat :bindaddr, default: "0.0.0.0"
  end

  class << self
    def opts
      @opts ||= DashOpts.new
    end
  end

  class RubyneatDashboard < Sinatra::Base
    helpers Sinatra::Streaming
    helpers Sinatra::JSON

    set :root, File.expand_path('..', File.dirname(__FILE__))
    set :logging, true
    set :server, 'thin'
    set :sockets, []

    register Barista::Integration::Sinatra
    register Sinatra::AssetPack
    register Sinatra::Contrib
    register Routing::Main
    register Routing::REST::Overview
    register BowerDSL
    register Rabl
    configure do
      set port: Dashboard::opts.port
      set static: true
      set :bind, Dashboard::opts.bindaddr
      use Rack::CommonLogger, $log = ::Logger.new(::File.new('log/dashboard.log', 'a+'))
      $log.debug "Started Dashboard at #{Time.now}"
      Barista.add_preamble do |location|
        %{
          /* RubyNEAT Dashboard Generated -- compiled from #{location}
           * DO NOT MODIFY
           */
        }
      end
      Rabl.configure do |config|
        config.include_json_root = true
        config.include_child_root = false
      end
    end

    assets do
      serve '/js',      from: 'app/js'           # Default
      serve '/css',     from: 'app/css'          # Default
      serve '/images',  from: 'app/images'       # Default
      bower_serve

      # The second parameter defines where the compressed version will be served.
      # (Note: that parameter is optional, AssetPack will figure it out.)
      js :app, '/js/app.js', bower( type: :js,
             modules: [
                        'angular',
                        'angular-animate',
                        'angular-resource',
                        'angular-route',
                        'angular-socket-io',
                        'angular-sanitize',
                        'jquery',
                        'foundation',
                        'angular-d3-directives',
                        'angular-pusher',
                      ]
            ) + ['/js/dashboard.js',
                 '/js/dashboard/*.js',
                 '/js/dashboard/**/*.js']

      css :application, '/css/application.css', bower(type: :css,
             modules: [
                        'foundation',
                        'angular',
                      ]
      ) + ['/css/vendor/*.css',
           '/css/dashboard.css',
           '/css/dashboard/**/*.css']

      #js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
      css_compression :simple   # :simple | :sass | :yui | :sqwish
    end
  end

  def self.run_dashboard!
    @@dashboard = Thread.new { Dashboard::RubyneatDashboard.run! }
  end

  def self.join!
    @@dashboard.join
  end
end

if __FILE__ == $0
  Dashboard::run_dashboard!
  at_exit { Dashboard::join! }
end
