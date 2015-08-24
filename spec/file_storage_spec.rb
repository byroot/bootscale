require 'spec_helper'
require 'bootscale/file_storage'

RSpec.describe Bootscale::FileStorage do
  around { |test| in_tmpdir(&test) }

  subject { Bootscale::FileStorage.new('tmp/bootscale') }

  it "dumps via Marshal by default" do
    expect(Bootscale::FileStorage::Serializer).to eq Marshal
  end

  it "can dump binary" do
    hash = {"\xDE" => 'utf-8'}
    subject.dump(%w(foo), hash)
    expect(subject.load(%w(foo))).to be == hash
  end
end
