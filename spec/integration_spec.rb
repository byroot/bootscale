require 'spec_helper'

RSpec.describe Bootscale do
  def sh(command)
    result = `#{command}`
    raise "FAILED #{result}" unless $?.success?
    result
  end

  def ordering(folders)
    in_tmpdir do
      folders.each do |folder|
        FileUtils.mkdir(folder)
        File.write("#{folder}/first.rb", "puts '#{folder}'")
      end

      sh("ruby #{Bundler.root}/spec/cases/order.rb 2>/dev/null")
    end
  end

  it "doesn't break application boot" do
    Dir.chdir(File.expand_path('../dummy', __FILE__)) do
      sh("bundle exec rails r '1 + 1'")
    end
  end

  it "can dump via msgpack" do
    in_tmpdir do
      sh("ruby #{Bundler.root}/spec/cases/message_pack.rb")
    end
  end

  it "requires in correct order" do
    expect(ordering(["three"])).to eq "three\n"
    expect(ordering(["one", "three"])).to eq "one\n"
  end

  it "requires in relative paths even when overwritten" do
    expect(ordering(["two", "three"])).to eq "two\n"
  end
end
