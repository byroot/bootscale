require 'msgpack'
require 'bootscale'
Bootscale.setup(cache_directory: 'tmp/bootscale')

raise unless MessagePack.load(File.read(Dir['tmp/bootscale/*'].first)).class == Hash
