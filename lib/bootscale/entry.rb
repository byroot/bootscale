module Bootscale
  class Entry
    DL_EXTENSIONS = [
      RbConfig::CONFIG['DLEXT'],
      RbConfig::CONFIG['DLEXT2'],
    ].reject { |ext| !ext || ext.empty? }.map { |ext| ".#{ext}"}
    REQUIREABLE_FILES = "**/*{#{DOT_RB},#{DL_EXTENSIONS.join(',')}}"
    NORMALIZE_NATIVE_EXTENSIONS = !DL_EXTENSIONS.include?(DOT_SO)
    ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN = /\.(o|bundle|dylib)\z/
    SLASH = '/'.freeze

    def initialize(path)
      @path = path.sub(/\/$/, '')
    end

    def requireables
      unless absolute = @path.start_with?(SLASH)
        warn "Bootscale: Cannot speedup load for relative path #{@path}"
      end
      includes_vendor_bundle = @path.end_with?("vendor") && File.exist?("#{@path}/bundle")

      relative_part = (@path.size + 1)..-1
      Dir[File.join(@path, REQUIREABLE_FILES)].each_with_object([]) do |absolute_path, all|
        relative_path = absolute_path.slice(relative_part)
        next if includes_vendor_bundle && relative_path.start_with?("bundle/")

        if NORMALIZE_NATIVE_EXTENSIONS
          relative_path.sub!(ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN, DOT_SO)
        end

        all << [relative_path, (absolute ? absolute_path : :relative)]
      end
    end
  end
end
