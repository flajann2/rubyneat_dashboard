module Dashboard
  module BowerDSL
    def self.extended(mod)
      unless mod.root?
        raise Error, "set root"
      end
      @root = mod.root
    end

    def self.gem_root; @root; end

    def packages

    end

  end
end

module Sinatra
  module AssetPack
    class Options

      def gem_root; @gem_root ||= Dashboard::BowerDSL.gem_root; end

      def bower_root(path = 'bower_components')
        @bower_root ||= path
      end

      def bower_route(path = '/bower')
        @bower_route ||= path
      end

      def bower_serve
        serve bower_route(), from: bower_root
      end

      def bower(type: nil, modules: [])

        modules.map {|mod| mod }
      end
    end
  end
end