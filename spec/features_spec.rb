RSpec.describe Bootscale::Features do
  let(:load_path) { File.expand_path('../dummy/app/controllers', __FILE__) }
  let(:cache_path) { Pathname.new(load_path).join('features.paths') }

  describe '.list' do
    it 'returns the list of requireable files in the provided path' do
      expect(Bootscale::Features.list(load_path)).to be == %w(
        application_controller.rb
        concerns/requireable.rb
      )
    end
  end

  describe '.dump and load' do
    let(:features) { ['foo.rb', 'bar baz.rb', "egg \t\nspam.rb"] }

    it 'handles paths with spaces, newlines and other craps' do
      expect(Bootscale::Features.load(Bootscale::Features.dump(features))).to be == features
    end
  end

  describe '.generate_cache' do
    after :each do
      cache_path.delete if cache_path.exist?
    end

    it 'creates a features.paths file' do
      expect {
        Bootscale::Features.generate_cache(load_path.to_s)
      }.to change { cache_path.exist? }.from(false).to(true)
    end
  end

  describe '.read_cache' do
    around :each do |example|
      Bootscale::Features.generate_cache(load_path.to_s)
      example.run
      cache_path.delete if cache_path.exist?
    end

    it 'returns the array of paths saved at the root' do
      expect(Bootscale::Features.read_cache(load_path)).to be == %w(
        application_controller.rb
        concerns/requireable.rb
      )
    end

    it "returns false if the cache doesn't exist" do
      expect(Bootscale::Features.read_cache(Dir.tmpdir)).to be false
    end
  end
end
