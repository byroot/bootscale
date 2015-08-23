require 'benchmark'

module Bootscale
  class Cache
    attr_reader :entries

    def initialize
      @entries = {}
      regenerate
    end

    def [](path)
      if path.end_with?(DOT_RB) || path.end_with?(DOT_SO)
        @cache[path]
      else
        @cache["#{path}#{DOT_RB}"] || @cache["#{path}#{DOT_SO}"]
      end
    end

    def regenerate
      ordered_entries = $LOAD_PATH.map { |path| entries.fetch(path) { Entry.new(path) } }
      @cache = Hash[ordered_entries.reverse.flat_map(&:features)]
    end
  end
end
