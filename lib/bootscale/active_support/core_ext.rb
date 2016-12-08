require 'active_support/dependencies'

module ActiveSupport
  module Dependencies
    undef_method :search_for_file

    # ActiveSupport::Dependencies.search_for_file works pretty much like Kernel#require.
    # It has a load path (AS::Dependencies.autoload_paths) and when it's looking for a file to load
    # it search the load path entries one by one for a match.
    # So just like for Kernel#require, this process is increasingly slow the more load path entries you have,
    # and it can be optimized with exactly the same caching strategy.
    def search_for_file(path)
      ::Bootscale::ActiveSupport.cache[path]
    end
  end
end
