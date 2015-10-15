require File.expand_path('../bootscale.rb', __FILE__)

Gem.post_install do |installer|
  installer.spec.full_require_paths.each do |path|
    STDERR.puts "[Bootscale] Generate cache in: #{path}"
    Bootscale::Features.generate_cache(path)
  end
end
