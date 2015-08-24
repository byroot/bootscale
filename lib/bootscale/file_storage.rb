require 'digest/md5'

module Bootscale
  class FileStorage
    def initialize(directory)
      @directory = directory
    end

    def load(load_path)
      path = cache_path(load_path)
      Serializer.load(File.read(path)) if File.exist?(path)
    end

    def dump(load_path, cache)
      path = cache_path(load_path)
      return if File.exist?(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, Serializer.dump(cache), mode: 'wb+')
    end

    if defined?(MessagePack)
      Serializer = MessagePack

      def cache_path(load_path)
        hash = Digest::MD5.hexdigest((load_path + [RUBY_VERSION, Bootscale::VERSION, MessagePack::VERSION]).join('|'))
        File.join(@directory, "bootscale-#{hash}.msgpack")
      end
    else
      Serializer = Marshal

      def cache_path(load_path)
        hash = Digest::MD5.hexdigest((load_path + [RUBY_VERSION, Bootscale::VERSION]).join('|'))
        File.join(@directory, "bootscale-#{hash}.marshal")
      end
    end
  end
end
