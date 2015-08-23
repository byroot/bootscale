module Bootscale
  class CacheBuilder
    attr_reader :entries

    def initialize
      @entries = {}
    end

    def generate(load_path)
      ordered_entries = load_path.map { |path| entries.fetch(path) { entries[path] = Entry.new(path) } }
      Hash[ordered_entries.reverse.flat_map(&:features)]
    end
  end
end
