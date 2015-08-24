require 'spec_helper'

RSpec.describe Bootscale::CacheBuilder do
  it "list all the files in the provided load paths" do
    cache = subject.generate(%w(spec/dummy/app/controllers spec/dummy/app/helpers))
    expect(cache.keys.sort).to be == %w(application_controller.rb application_helper.rb)
  end

  it "doesn't break if elements of the load path are Pathname instances" do
    cache = subject.generate([Pathname.new('spec/dummy/app/controllers')])
    expect(cache.keys.sort).to be == %w(application_controller.rb)
  end
end
