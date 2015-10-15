require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require 'rake/extensiontask'
GEMSPEC = eval(File.read('bootscale.gemspec'))
Rake::ExtensionTask.new('_bootscale', GEMSPEC) do |ext|
  ext.ext_dir = 'ext/bootscale'
  ext.lib_dir = 'lib/bootscale'
end
task :build => :compile


RSpec::Core::RakeTask.new(:spec)
task :spec => :build

task :default => :spec
