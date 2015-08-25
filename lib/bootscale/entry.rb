module Bootscale
  class Entry
    DL_EXTENSIONS = [
      RbConfig::CONFIG['DLEXT'],
      RbConfig::CONFIG['DLEXT2'],
    ].reject { |ext| !ext || ext.empty? }.map { |ext| ".#{ext}"}
    FEATURE_FILES = "**/*{#{DOT_RB},#{DL_EXTENSIONS.join(',')}}"
    NORMALIZE_NATIVE_EXTENSIONS = !DL_EXTENSIONS.include?(DOT_SO)
    ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN = /\.(o|bundle|dylib)\z/

    def initialize(path)
      @path = path
    end

    def features
      path_prefix = @path.end_with?('/'.freeze) ? @path : "#{@path}/"
      Dir[File.join(@path, FEATURE_FILES)].map do |absolute_path|
        relative_path = absolute_path.sub(path_prefix, ''.freeze)

        if NORMALIZE_NATIVE_EXTENSIONS
          relative_path.sub!(ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN, DOT_SO)
        end

        [relative_path, absolute_path]
      end
    end
  end
end
