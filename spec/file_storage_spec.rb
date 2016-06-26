require 'spec_helper'
require 'bootscale/file_storage'

RSpec.describe Bootscale::FileStorage do
  around { |test| in_tmpdir(&test) }

  subject { Bootscale::FileStorage.new(Dir.pwd) }

  it "dumps via Marshal by default" do
    expect(Bootscale::FileStorage::Serializer).to eq Marshal
  end

  it "can dump binary" do
    hash = {"\xDE" => 'utf-8'}
    subject.dump(%w(foo), hash)
    expect(subject.load(%w(foo))).to be == hash
  end

  context 'concurrent' do
    it 'should not read garbage' do
      load_path = %w[foo].freeze
      expect do
        threads = 100.times.map do |i|
          Thread.new(subject) do |storage|
            i.odd? ? storage.load(load_path) : storage.dump(load_path, 'a' * 100_000)
          end
        end
        threads.map(&:join)
      end.not_to raise_error
    end
  end
end
