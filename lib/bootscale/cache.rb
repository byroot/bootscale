require_relative 'file_storage'

module Bootscale
  class Cache
    def initialize(cache_directory = nil)
      @storage = FileStorage.new(cache_directory) if cache_directory
      reload
    end

    def load_path
      $LOAD_PATH
    end

    def reload(force = true)
      @cache = fetch(load_path) if force
    end

    def [](path)
      path = path.to_s
      return if path.start_with?(LEADING_SLASH)
      reload(false)
      if path.end_with?(DOT_RB, DOT_SO)
        @cache[path]
      else
        @cache["#{path}#{DOT_RB}"] || @cache["#{path}#{DOT_SO}"]
      end
    end

    private

    attr_reader :storage

    def fetch(load_path)
      load || save(Bootscale.cache_builder.generate(load_path))
    end

    def load
      return unless storage
      storage.load(load_path)
    end

    def save(cache)
      return cache unless storage
      storage.dump(load_path, cache)
      cache
    end
  end
end
