require_relative 'file_storage'

module Bootscale
  class Cache
    attr_reader :load_path

    def initialize(load_path, cache_directory = nil)
      @load_path = load_path
      @storage = FileStorage.new(cache_directory) if cache_directory
      @cache = load || save(Bootscale.cache_builder.generate(load_path))
    end

    def [](path)
      path = path.to_s
      return if path.start_with?(LEADING_SLASH)
      if path.end_with?(DOT_RB, DOT_SO)
        @cache[path]
      else
        @cache["#{path}#{DOT_RB}"] || @cache["#{path}#{DOT_SO}"]
      end
    end

    private

    attr_reader :storage

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
