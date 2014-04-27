require 'sinatra/base'
require 'barista'
require 'sass/plugin/rack'

class RubyneatDashboard < Sinatra::Base
  register Barista::Integration::Sinatra

  Sass::Plugin.options[:style] = :compressed
  use Sass::Plugin::Rack

  configure do
    set port: 3912
    set static: true
  end

  get '/' do
    haml :index
  end
end


RubyneatDashboard.run!


