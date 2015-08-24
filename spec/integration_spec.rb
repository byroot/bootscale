require 'spec_helper'

RSpec.describe Bootscale do
  def in_tmpdir(&block)
    Dir.mktmpdir('bootscale') { |dir| Dir.chdir(dir, &block) }
  end

  it "doesn't break application boot" do
    Dir.chdir(File.expand_path('../dummy', __FILE__)) do
      expect(system("bundle exec rails r '1 + 1'")).to be true
    end
  end

  it "can dump via msgpack" do
    in_tmpdir do
      expect(system("ruby #{Bundler.root}/spec/cases/message_pack.rb")).to be true
    end
  end
end
