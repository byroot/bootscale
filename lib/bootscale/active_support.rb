module Bootscale
  module ActiveSupport
    class Cache < ::Bootscale::Cache
      def load_path
        ::ActiveSupport::Dependencies.autoload_paths
      end

      # Ideally we'd use a more accurate comparison like `#hash`, unfortunately it's
      # not efficient enough given how much of a hot spot this is.
      # So we assume entries are not mutated or replaced, only added or removed.
      # It is obviously wrong sometimes, and you'll have to manually call Bootscale.regenerate
      def reload(force = true)
        @load_path_size ||= nil

        if force
          @cache = fetch(load_path)
          @load_path_size = load_path.size
        elsif (size = load_path.size) != @load_path_size
          @cache = fetch(load_path)
          @load_path_size = size
        end
      end
    end

    class << self
      attr_reader :cache, :cache_directory

      def cache_builder
        @cache_builder ||= CacheBuilder.new
      end

      def setup(options = {})
        @cache_directory = options.fetch(:cache_directory, Bootscale.cache_directory)
        require 'active_support/dependencies'
        @cache = Cache.new(cache_directory)
        require_relative 'active_support/core_ext'
      end
    end
  end
end
