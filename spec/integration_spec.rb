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
end
