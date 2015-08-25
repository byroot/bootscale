module Bootscale
  class CacheBuilder
    def initialize
      @entries = {}
    end

    # this fills in missing entries, it is not a complete regeneration, so for example removing a load-path would not remove the paths
    # same for changing load-path order or modifying something inside of a load-path
    # TODO rename or fix
    def generate(load_path)
      ordered_features = load_path.reverse_each.flat_map do |path|
        path = path.to_s
        entries[path] ||= Entry.new(path).features
      end
      Hash[ordered_features]
    end

    private

    attr_reader :entries
  end
end
