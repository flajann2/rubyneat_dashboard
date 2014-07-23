require 'logger'

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
      files.map do |file|
        File.expand_path file, File.expand_path(pkg, bower_route)
      end
    end

    # generates a list of Bower package names and their json manifests [pkgname, manifest]
    def bower_packages
      @bower_packages ||= Dir["#{File.expand_path(bower_root, gem_root)}/*/.bower.json"].
          map{ |path| [File.basename(File.dirname(path)), File.read(path)] }.
          map{ |pkg, json| [pkg, JSON::Stream::Parser.parse(json) ]}.
          map{ |pkg, manifest| [pkg, manifest['main'], manifest['version'], manifest['dependencies']] }.
          map{ |pkg, files, ver, deps| [pkg, ver, files || "#{pkg}.js", deps]}.
          inject({}){ |memo, (pkg, ver, files, deps)|
                        memo[pkg] = { files: path_to(pkg, files.kind_of?(String)? [files] : files),
                                       deps: deps,
                                    version: ver}
                        memo
                    }
    end

    def bower_no_deps?(mod)
      bower_resolve(mod)[:deps].nil? or bower_resolve(mod)[:deps].empty?
    end

    # The parameter may either be a module (string), or a [module, ver] pair.
    # Find and return the matchinng module, or throw an exception if the
    # resolution fails.
    def bower_resolve(modspec)
      mod, verspec =  if modspec.kind_of?(Array)
                        modspec
                      else
                        [modspec, '>=0.0.0']
                      end
      raise DashboardException.new("Missing Asset Module #{mod} version #{verspec}") if bower_packages[mod].nil?
      bower_packages[mod] # FIXME: must check for version match too!!!
    end
  end
end

module Sinatra
  module AssetPack
    class Options
      include Dashboard::BowerHelpers

      def resolve_dependencies(mods, notes=[])
        mods.inject([]) do |memo, modspec|
          mod, ver = modspec.kind_of?(Array) ? modspec : [modspec, '>=0.0.0']
          memo  << mod
          memo  << resolve_dependencies(bower_resolve(mod)[:deps], notes) unless bower_no_deps?(mod) or notes.member?(mod)
          notes << mod
          memo
        end.flatten
      end

      def bower(type: nil, modules: [])
        r = resolve_dependencies(modules).map{|mod| bower_resolve(mod)[:files] }.flatten
          .select { |file| file =~ %r{\.#{type}$} }
        $log.debug r
        r
      end
    end
  end
end