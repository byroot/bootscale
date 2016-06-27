module Bootscale
  module Utils
    # Write to a file atomically. Useful for situations where you
    # don't want other processes or threads to see half-written files.
    #
    #   Utils.atomic_write('important.file') do |file|
    #     file.write('hello')
    #   end
    #
    # Returns nothing.
    def self.atomic_write(filename)
      dirname, basename = File.split(filename)
      basename = [
          basename,
          Thread.current.object_id,
          Process.pid,
          rand(1000000)
      ].join('.'.freeze)
      tmpname = File.join(dirname, basename)

      File.open(tmpname, 'wb+') do |f|
        yield f
      end

      File.rename(tmpname, filename)
    ensure
      File.delete(tmpname) if File.exist?(tmpname)
    end
  end
end
