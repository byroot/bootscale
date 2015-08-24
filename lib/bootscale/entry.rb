module Bootscale
  class Entry
    DL_EXTENSIONS = [
      RbConfig::CONFIG['DLEXT'],
      RbConfig::CONFIG['DLEXT2'],
    ].reject { |ext| ext.nil? || ext.empty? }.map { |ext| ".#{ext}"}
    FEATURE_FILES = "**/*{#{DOT_RB},#{DL_EXTENSIONS.join(',')}}"
    NORMALIZE_NATIVE_EXTENSIONS = !DL_EXTENSIONS.include?(DOT_SO)
    ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN = /\.(o|bundle|dylib)\z/

    attr_reader :path, :features

    def initialize(path)
      @path = path
      @path_prefix = path.end_with?('/'.freeze) ? path : "#{path}/"
      @features = list_features
    end

    private

    def list_features
      Dir[File.join(path, FEATURE_FILES)].map do |absolute_path|
        relative_path = absolute_path.sub(@path_prefix, ''.freeze)

        if NORMALIZE_NATIVE_EXTENSIONS
          relative_path.sub!(ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN, DOT_SO)
        end

        [relative_path, absolute_path]
      end
    end
  end
end
