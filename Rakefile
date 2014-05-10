# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'semver'

def s_version
  SemVer.find.format "%M.%m.%p%s"
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "rubyneat_dashboard"
  gem.homepage = "http://rubyneat.com"
  gem.license = "MIT"
  gem.version = s_version
  gem.summary = %Q{RubyNEAT Dashboard}
  gem.description = %Q{A web-based dashboard for your RubyNEAT development, http://localhost:3912/}
  gem.email = "fred@lrcsoft.com"
  gem.authors = ["Fred Mitchell"]
  # dependencies defined in Gemfile
  gem.files.exclude 'foo/**/*', 'rdoc/*',
                    '.idea/**/*', '.idea/**/.*', '.yardoc/**/*',
                    'app/**/*', 'doc/**/*',
                    'app/**/.*', 'Guardfile'
end

Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
