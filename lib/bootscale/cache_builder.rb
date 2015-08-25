module Bootscale
  class CacheBuilder
    def initialize
      @entries = {}
    end

    # generate the requireables cache from all current load-path entries
    # each load-path is cached individually, so new ones can be added or removed
    # but added/removed files will not be discovered
    def generate(load_path)
      requireables = load_path.reverse_each.flat_map do |path|
        path = path.to_s
        entries[path] ||= Entry.new(path).requireables
      end
      Hash[requireables]
    end

    private

    attr_reader :entries
  end
end
