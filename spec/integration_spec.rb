require 'spec_helper'

RSpec.describe Bootscale do
  it "doesn't break application boot" do
    Dir.chdir(File.expand_path('../dummy', __FILE__)) do
      expect(system("bundle exec rails r '1 + 1'")).to be true
    end
  end
end
