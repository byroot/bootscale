require 'digest/md5'

module Bootscale
  class FileStorage
    PACKER = (defined?(MessagePack) ? MessagePack : Marshal)

    def initialize(directory)
      @directory = directory
    end

    def load(load_path)
      path = cache_path(load_path)
      PACKER.load(File.read(path)) if File.exist?(path)
    end

    def dump(load_path, cache)
      path = cache_path(load_path)
      return if File.exist?(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, PACKER.dump(cache))
    end

    def cache_path(load_path)
      packer_version = (PACKER == Marshal ? '' : PACKER::VERSION)
      hash = Digest::MD5.hexdigest((load_path + [RUBY_VERSION, Bootscale::VERSION, packer_version]).join('|'))
      File.join(@directory, "bootscale-#{hash}.msgpack")
    end
  end
end
