ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootscale'
Bootscale.setup(cache_directory: File.expand_path('../../tmp/bootscale', __FILE__))
