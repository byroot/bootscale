module Bootscale
  module Features
    CACHE_FILE_NAME = 'features.paths'

    extend self

    def read_cache(path)
      load(File.read(File.join(path, CACHE_FILE_NAME)))
    rescue Errno::ENOENT
      false
    end

    def generate_cache(path)
      File.write(File.join(path, CACHE_FILE_NAME), dump(list(path)))
    end

    def list(path)
      # TODO: Deprecate and get rid of the entry class reorganize everything here
      Entry.new(path).requireables.map(&:first)
    end

    def dump(features)
      features.join("\0")
    end

    def load(payload)
      payload.split("\0")
    end
  end
end