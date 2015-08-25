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
      @path = path
    end

    def requireables
      return [] unless @path.start_with?(SLASH)
      path_prefix = (@path.end_with?(SLASH) ? @path.size : @path.size + 1)
      relative_part = path_prefix..-1
      Dir[File.join(@path, REQUIREABLE_FILES)].map do |absolute_path|
        relative_path = absolute_path.slice(relative_part)

        if NORMALIZE_NATIVE_EXTENSIONS
          relative_path.sub!(ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN, DOT_SO)
        end

        [relative_path, absolute_path]
      end
    end
  end
end
