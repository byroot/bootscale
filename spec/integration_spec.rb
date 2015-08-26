require 'spec_helper'

RSpec.describe Bootscale do
  def sh(command)
    result = `#{command}`
    raise "FAILED: #{result}" unless $?.success?
    result
  end

  def run_example(code)
    in_tmpdir do
      files = code.split(/^ +# (.*\.rb)\n/)[1..-1].each_slice(2).to_a
      files.each do |file, code|
        FileUtils.mkdir_p(File.dirname(file))
        File.write(file, code)
      end
      sh("ruby #{files.last.first} 2>/dev/null")
    end
  end

  it "doesn't break application boot" do
    Dir.chdir(File.expand_path('../dummy', __FILE__)) do
      sh("bundle exec rails r '1 + 1'")
    end
  end

  it "can dump via msgpack" do
    result = run_example <<-RUBY
      # test.rb
      require 'msgpack'
      require 'bootscale/setup'

      puts MessagePack.load(File.read(Dir['tmp/bootscale/*'].first)).class
    RUBY
    expect(result).to eq "Hash\n"
  end

  it "requires in correct order" do
    result = run_example <<-RUBY
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
    expect(result).to eq "[2]\n"
  end

  it "requires in relative paths even when overwritten" do
    result = run_example <<-RUBY
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
    expect(result).to eq "[2]\n"
  end
end
