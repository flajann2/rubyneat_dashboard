require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/streaming'
require 'barista'
require 'sass'
require 'haml'
require 'logger'
require_relative 'rubyneat_dashboard/main'

Logger.class_eval { alias :write :'<<' }

module Dashboard
  class RubyneatDashboard < Sinatra::Base
    helpers Sinatra::Streaming
    
    set :root, File.expand_path('..', File.dirname(__FILE__))
    set :logging, true
    set :server, 'thin'
    set :sockets, []

    register Barista::Integration::Sinatra
    register Sinatra::AssetPack
    register Routing::Main
    register Routing::REST::Overview
    register BowerDSL

    configure do
      set port: 3912
      set static: true
      use Rack::CommonLogger, $log = ::Logger.new(::File.new('log/dashboard.log', 'a+'))
      $log.debug "Started Dashboard at #{Time.now}"
      Barista.add_preamble do |location|
        %{
          /* DO NOT MODIFY -- compiled from #{location}
           */
        }
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
            ) + ['/js/dashboard.js','/js/dashboard/*.js','/js/vendor/**/*.js']

      css :application, '/css/application.css', bower(type: :css,
             modules: ['foundation']
      ) + ['/css/vendor/*.css', '/css/dashboard.css', '/css/dashboard/*.css']

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
