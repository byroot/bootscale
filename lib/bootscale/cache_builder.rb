module Bootscale
  class CacheBuilder
    attr_reader :entries

    def initialize
      @entries = {}
    end

    def generate(load_path)
      ordered_entries = load_path.map do |path|
        path = path.to_s
        entries[path] ||= Entry.new(path)
      end
      Hash[ordered_entries.reverse.flat_map(&:features)]
    end
  end
end
