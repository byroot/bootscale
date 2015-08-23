require_relative 'bootscale/version'

module Bootscale
  DOT_SO = '.so'.freeze
  DOT_RB = '.rb'.freeze

  class << self
    def [](path)
      path = path.to_s
      if path.end_with?(DOT_RB) || path.end_with?(DOT_SO)
        cache[path]
      else
        cache["#{path}#{DOT_RB}"] || cache["#{path}#{DOT_SO}"]
      end
    end

    def setup(options = {})
      self.cache_directory = options[:cache_directory]
      require_relative 'bootscale/setup'
      regenerate
    end

    def regenerate
      @cache = load_cache || save_cache(cache_builder.generate($LOAD_PATH))
    end

    def cache
      @cache ||= {}
    end

    def cache_builder
      @cache_builder ||= CacheBuilder.new
    end

    def load_cache
      return unless storage
      storage.load($LOAD_PATH)
    end

    def save_cache(cache)
      return cache unless storage
      storage.dump($LOAD_PATH, cache)
      cache
    end

    attr_accessor :storage

    def cache_directory=(directory)
      if directory
        require_relative 'bootscale/file_storage'
        self.storage = FileStorage.new(directory)
      else
        self.storage = nil
      end
    end
  end
end

require_relative 'bootscale/entry'
require_relative 'bootscale/cache_builder'
