module Dashboard
  module BowerDSL
    def self.extended(mod)
      unless mod.root?
        raise Error, "set root"
      end
      @root = mod.root
    end

    def self.gem_root; @root; end
  end

  module BowerHelpers
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

    def path_to(pkg, files)
      File.expand_path
    end

    # generates a list of Bower package names and their json manifests [pkgname, manifest]
    def bower_packages
      @bower_packages ||= Dir["#{File.expand_path(bower_root, gem_root)}/*/.bower.json"].
          map{ |path| [File.basename(File.dirname(path)), File.read(path)] }.
          map{ |pkg, json| [pkg, JSON::Stream::Parser.parse(json) ]}.
          map{ |pkg, manifest| [pkg, manifest['main'], manifest['dependencies']] }.
          map{ |pkg, files, deps| [pkg, files || "#{pkg}.js", deps]}.
          inject({}){ |memo, (pkg, files, deps)| memo[pkg] = { files: files.kind_of?(String)
                                                                            ? [files]
                                                                            : files,
                                                               deps: deps}; memo }
    end

  end
end

module Sinatra
  module AssetPack
    class Options
      include Dashboard::BowerHelpers

      def bower(type: nil, modules: [])

        modules.map {|mod| mod }
      end
    end
  end
end