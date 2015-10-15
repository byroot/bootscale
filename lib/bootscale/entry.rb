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

    if defined?(Bundler)
      BUNDLE_PATH = Bundler.bundle_path.cleanpath.to_s << SLASH
    end

    def initialize(path)
      @path = Pathname.new(path).cleanpath
      @absolute = @path.absolute?
      warn "Bootscale: Cannot speedup load for relative path #{@path}" unless @absolute
      @relative_slice = (@path.to_s.size + 1)..-1
      @contains_bundle_path = defined?(BUNDLE_PATH) && BUNDLE_PATH.start_with?(@path.to_s)
    end

    def requireables
      Dir[File.join(@path, REQUIREABLE_FILES)].each_with_object([]) do |absolute_path, all|
        next if @contains_bundle_path && absolute_path.start_with?(BUNDLE_PATH)
        relative_path = absolute_path.slice(@relative_slice)

        if NORMALIZE_NATIVE_EXTENSIONS
          relative_path.sub!(ALTERNATIVE_NATIVE_EXTENSIONS_PATTERN, DOT_SO)
        end

        all << [relative_path, @absolute && absolute_path]
      end
    end
  end
end
