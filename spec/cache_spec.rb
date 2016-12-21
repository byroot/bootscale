require 'spec_helper'

RSpec.describe 'caches' do
  let(:files) do
    %w(
      a/foo.rb
      b/foo.rb
      b/bar.rb
    )
  end

  let(:load_path) { %w(a b).map { |d| File.join(tmpdir, d) } }

  let!(:tmpdir) { Dir.mktmpdir }

  before do
    allow_any_instance_of(described_class).to receive(:load_path).and_return(load_path)
    Bootscale.cache_builder.clear!
    files.each do |relative_path|
      absolute_path = File.join(tmpdir, relative_path)
      FileUtils.mkdir_p(File.dirname(absolute_path))
      File.write(absolute_path, '')
    end
  end

  after do
    FileUtils.rm_rf(tmpdir)
  end

  subject { described_class.new(load_path) }

  describe Bootscale::Cache do
    it 'returns the absolute path' do
      expect(subject['foo.rb']).to be_an_absolute_path
    end

    it 'returns nil on miss' do
      expect(subject['plop.rb']).to be_nil
    end

    it "doesn't catch changes on the file system" do
      expect {
        File.delete(subject['foo.rb'])
      }.to_not change { subject['foo.rb'] }

      expect {
        File.write(File.join(tmpdir, 'a', 'bar.rb'), '')
      }.to_not change { subject['bar.rb'] }
    end
  end

  describe Bootscale::DevelopmentCache do
    it 'returns the absolute path' do
      expect(subject['foo.rb']).to be_an_absolute_path
    end

    it 'returns nil on miss' do
      expect(subject['plop.rb']).to be_nil
    end

    it 'automatically regenerates when a cached path is moved or deleted' do
      expect {
        File.delete(subject['foo.rb'])
      }.to change { subject['foo.rb'] }
    end

    it 'automatically regenerates when a new path overrides a cached one' do
      pending "This case isn't supported. Yet? Maybe with an inotify integration?"
      expect {
        File.write(File.join(tmpdir, 'a', 'bar.rb'), '')
      }.to change { subject['bar.rb'] }
    end
  end
end
