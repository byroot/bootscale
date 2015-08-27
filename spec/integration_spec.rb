require 'spec_helper'

RSpec.describe Bootscale do
  it "doesn't break application boot" do
    expect {
      Dir.chdir(File.expand_path('../dummy', __FILE__)) do
        system("bundle exec rails r 'p 1 + 1'")
      end
    }.to output("2\n").to_stdout_from_any_process
  end

  it "can dump via msgpack" do
    expect {
      <<-RUBY
        # test.rb
        require 'msgpack'
        require 'bootscale/setup'

        puts MessagePack.load(File.read(Dir['tmp/bootscale/*'].first)).class
      RUBY
    }.to echo "Hash\n"
  end

  it "requires in correct order" do
    expect {
      <<-RUBY
        # one/load.rb
        $test << 1

        # two/load.rb
        $test << 2

        # test.rb
        $LOAD_PATH << File.expand_path('two')
        $LOAD_PATH << File.expand_path('one')
        $test = []
        require 'bootscale/setup'
        require 'load'

        puts $test.inspect
      RUBY
    }.to echo "[2]\n"
  end

  it "requires in relative paths even when overwritten" do
    expect {
      <<-RUBY
        # one/load.rb
        $test << 1

        # two/load.rb
        $test << 2

        # test.rb
        $LOAD_PATH << 'two'
        $LOAD_PATH << File.expand_path('one')
        $test = []
        require 'bootscale/setup'
        require 'load'

        puts $test.inspect
      RUBY
    }.to echo "Bootscale: Cannot speedup load for relative path two\n[2]\n"
  end

  it "does not cache vendor/bundle in the load path since that duplicates all known files" do
    expect {
      <<-RUBY
        # vendor/bundle/gems/active_support-2.1.3/foo/bar.rb
        $test << 1

        # vendor/foo.rb
        $test << 2

        # lib/bundle/baz.rb
        $test << 3

        # rails.rb
        $LOAD_PATH << File.expand_path('vendor') # rails does that by default
        $LOAD_PATH << File.expand_path('lib') # making sure not everything with /bundle/ is ignored
        $LOAD_PATH << File.expand_path('vendor/bundle/gems/active_support-2.1.3')
        $test = []

        require 'bootscale/setup'

        puts "not cached: \#{!!Bootscale['bundle/gems/active_support-2.1.3/foo/bar']}"
        puts "cached 1: \#{!!Bootscale['foo/bar']}"
        puts "cached 2: \#{!!Bootscale['bundle/baz']}"

        require 'foo/bar' # normal require from real load path
        require 'foo' # normal require from vendor load path
        require 'bundle/baz' # normal require from bundle load path
        require 'bundle/gems/active_support-2.1.3/foo/bar' # nested require still works since we fall back

        puts $test.inspect
      RUBY
    }.to echo "not cached: false\ncached 1: true\ncached 2: true\n[1, 2, 3]\n"
  end
end
