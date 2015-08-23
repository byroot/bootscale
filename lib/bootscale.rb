require_relative 'bootscale/version'
require_relative 'bootscale/entry'
require_relative 'bootscale/cache'

module Bootscale
  class << self
    def [](path)
      cache[path.to_s] || path
    end

    def regenerate
      cache.regenerate
    end

    def cache
      @cache ||= Cache.new
    end
  end
end

require_relative 'bootscale/setup'
