require 'spec_helper'

RSpec.describe Bootscale::CacheBuilder do
  it "list all the files in the provided load paths" do
    cache = subject.generate([File.expand_path("spec/dummy/app/controllers"), File.expand_path("spec/dummy/app/helpers")])
    expect(cache.keys.sort).to eq %w(application_controller.rb application_helper.rb)
  end

  it "doesn't break if elements of the load path are Pathname instances" do
    cache = subject.generate([Pathname.new(File.expand_path('spec/dummy/app/controllers'))])
    expect(cache.keys.sort).to eq %w(application_controller.rb)
  end

  it "marks relative paths since they do not work normally or when switching directories" do
    expect_any_instance_of(Bootscale::Entry).to receive(:warn)
    cache = subject.generate(['spec/dummy/app/controllers'])
    expect(cache).to eq "application_controller.rb" => false
  end
end
