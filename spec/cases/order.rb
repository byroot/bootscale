$LOAD_PATH << File.expand_path('one')
$LOAD_PATH << 'two'
$LOAD_PATH << File.expand_path('three')

require 'bootscale/setup'
require 'first'
